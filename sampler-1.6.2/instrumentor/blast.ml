open Cil


let addBlastMarkers =
  Options.registerBoolean
    ~flag:"add-blast-markers"
    ~desc:"add markers at each instrumentation site for use with BLAST model checker"
    ~ident:"AddBlastMarkers"
    ~default:false


let saveBlastSpec =
  Options.registerString
    ~flag:"save-blast-spec"
    ~desc:"save BLAST model checker specification in the named file"
    ~ident:""


let predicateMarker2 file =
  if !addBlastMarkers then
    let markerFunc = Lval (var (FindFunction.find "cbi_blastMarker" file)) in
    let specChannel = open_out !saveBlastSpec in
    fun siteId predExpr location ->
      Printf.fprintf specChannel "global int pred_%d_0 = 0;\n" siteId;
      Printf.fprintf specChannel "global int pred_%d_1 = 0;\n" siteId;
      Printf.fprintf specChannel "\n";
      Printf.fprintf specChannel "event {\n";
      Printf.fprintf specChannel "  pattern { blastMarker(%d, $1); }\n" siteId;
      Printf.fprintf specChannel "  action { if ($1) pred_%d_1 = 1; else pred_%d_0 = 1; }\n" siteId siteId;
      Printf.fprintf specChannel "}\n\n";
      let siteId = integer siteId in
      let call = Call (None, markerFunc, [siteId; predExpr], location) in
      mkStmtOneInstr call

  else
    fun _ _ _ -> mkEmptyStmt ()


class visitor file =
  let markerFunc = Lval (var (FindFunction.find "cbi_blastTerminationMarker" file)) in
  let markerCall location = mkStmtOneInstr (Call (None, markerFunc, [], location)) in

  object (self)
    inherit nopCilVisitor

    val mutable inMain = false
    val mutable dangerous = false

    method private post stmt =
      if dangerous then
	begin
	  dangerous <- false;
	  stmt.skind <- Block (mkBlock [markerCall !currentLoc; mkStmt stmt.skind])
	end;
      stmt

    method vfunc func =
      inMain <- (func.svar.vname = "main");
      DoChildren

    method vstmt stmt =
      if inMain then
	begin
	  match stmt.skind with
	  | Return _ -> dangerous <- true
	  | _ -> ()
	end;
      ChangeDoChildrenPost (stmt, self#post)

    method vinst instr =
      begin
	match instr with
	| Set _ -> ()
	| Call (_, callee, _, _)
	  when hasAttribute "noreturn" (typeAttrs (typeOf callee)) ->
	    dangerous <- true
	| Call (_, _, _, _) -> ()
	| Asm _ -> dangerous <- true
      end;
      DoChildren

    method vlval lval =
      begin
	match lval with
	| Mem _, _ -> dangerous <- true
	| Var _, _ -> ()
      end;
      DoChildren

    method voffs offset =
      begin
	match offset with
	| Index _ -> dangerous <- true
	| Field _ -> ()
	| NoOffset -> ()
      end;
      DoChildren

  end


let markTerminations file =
  if !addBlastMarkers then
    let visitor = new visitor file in
    visitCilFileSameGlobals visitor file
