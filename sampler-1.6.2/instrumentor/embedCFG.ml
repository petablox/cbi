open Cil


let saveCFG =
  Options.registerString
    ~flag:"save-cfg"
    ~desc:"save control flow graph in the named file"
    ~ident:""


let dumpBase =
  Options.registerString
    ~flag:"dumpbase"
    ~desc:"original source file name"
    ~ident:""


class visitor file digest channel =
  object (self)
    inherit FunctionBodyVisitor.visitor

    initializer
      let filename =
	if !dumpBase = "" then file.fileName
	else !dumpBase
      in
      Printf.fprintf channel
	"*\t0.1\n%s\n%s\n"
	filename
	(Digest.to_hex (Lazy.force digest))

    val expectedSid = ref 0

    method private addLocation location =
      let file =
	if location.file = "" then
	  Pretty.text "(unknown)"
	else
	  Paths.normalize location
      in
      let line = if location.line = -1 then 0 else location.line in
      ignore (Pretty.fprintf channel "%t\t%d\n" (fun () -> file) line)

    method postNewline thing =
      output_char channel '\n';
      thing

    method vfunc fundec =
      Printf.fprintf channel
	"%c\t%s\t"
	(if fundec.svar.vstorage == Static then '-' else '+')
	fundec.svar.vname;
      self#addLocation fundec.svar.vdecl;

      CfgUtils.build fundec;
      expectedSid := 0;

      ChangeDoChildrenPost (fundec, self#postNewline)

    method vstmt statement =
      assert (statement.sid == !expectedSid);
      incr expectedSid;

      (* statement location *)
      self#addLocation (get_stmtLoc statement.skind);

      (* successors list *)
      let addSucc {sid = succId} =
	Printf.fprintf channel "%d\t" succId
      in
      List.iter addSucc statement.succs;
      output_char channel '\n';

      (* callees list *)
      begin
	match IsolateInstructions.isolated statement with
	|  Some (Call (_, Lval callee, _, _)) ->
	    begin
	      match Dynamic.resolve callee with
	      | Dynamic.Unknown ->
		  output_string channel "???"
	      | Dynamic.Known callees ->
		  let addCallee {vname = vname} =
		    output_string channel vname;
		    output_char channel '\t'
		  in
		  List.iter addCallee callees
	    end

	| Some (Call (_, callee, _, _)) ->
	    ignore (bug "unexpected non-lval callee: %a" d_exp callee);
	    failwith "internal error"

	| _ ->
	    ()
      end;
      output_char channel '\n';

      DoChildren
  end


let visit file digest =
  if !saveCFG <> "" then
    TestHarness.time "saving CFG"
      (fun () ->
	let channel = open_out !saveCFG in
	let visitor = new visitor file digest channel in
	visitCilFileSameGlobals (visitor :> cilVisitor) file;
	output_char channel '\n';
	close_out channel)
