open Cil
open Pretty


let saveDataflow =
  Options.registerString
    ~flag:"save-dataflow"
    ~desc:"save data flow information in the named file"
    ~ident:""


let saveDataflowFields =
  Options.registerBoolean
    ~flag:"save-dataflow-fields"
    ~desc:"include structure fields in data flow information"
    ~ident:""
    ~default:false


type value = Unknown | Complex | Simple of doc


let anything = chr '*'
let arrayElem = chr '@'


let rec isInterestingType = function
  | TInt _
  | TPtr _
  | TEnum _ ->
      true
  | TNamed ({ttype = ttype}, _) ->
      isInterestingType ttype
  | TBuiltin_va_list _ | TComp _ | TFun _ | TArray _ | TFloat _ | TVoid _ ->
      false


let rec onlyFields = function
  | NoOffset -> true
  | Field ({fcomp = {cstruct = true}}, offset)
    when !saveDataflowFields ->
      onlyFields offset
  | Field _
  | Index _ -> false


let collectLval result lval =
  match snd (removeOffset (snd lval)) with
  | Index _ -> arrayElem :: result
  | NoOffset
  | Field _ ->
      let isDirect =
	match (fst lval) with
	| Mem _ -> false
	| Var _ -> onlyFields (snd lval)
      in
      let rec traverse result name typ =
	match typ with
	| TVoid _
	| TFloat _
	| TArray _
	| TFun _
	| TBuiltin_va_list _ ->
	    result
	| TInt _
	| TPtr _
	| TEnum _ ->
	    (if isDirect then name else anything) :: result
	| TNamed ({ttype = ttype}, _) ->
	    traverse result name ttype
	| TComp ({cstruct = true; cfields = cfields}, _)
	  when !saveDataflowFields ->
	    let prefix = name ++ chr '.' in
	    List.fold_left
	      (fun result fieldinfo ->
		traverse result (prefix ++ text fieldinfo.fname) fieldinfo.ftype)
	      result cfields
	| TComp _ ->
	    result
      in
      traverse result (d_lval () lval) (typeOfLval lval)


let collectVar result varinfo =
  collectLval result (var varinfo)


let collectExpr result expr =
  let rec collect result = function
    | Const (CInt64 (value, _, _)) ->
	text (Int64.to_string value) :: result
    | Const (CChr character) ->
	num (Char.code character) :: result
    | Const (CStr _) ->
	anything :: result
    | Const (CEnum (exp, _, _)) ->
	let contribution =
	  match isInteger exp with
	  | Some value -> text (Int64.to_string value)
	  | None -> anything
	in
	contribution :: result
    | Const (CWStr _)
    | Const (CReal _) ->
	result
    | Lval lval ->
	collectLval result lval
    | SizeOf _
    | SizeOfE _
    | SizeOfStr _
    | AlignOf _
    | AlignOfE _ ->
	anything :: result
    | UnOp (_, _, typ)
    | BinOp (_, _, _, typ) ->
	if isInterestingType typ then
	  anything :: result
	else
	  result
    | CastE (_, expr) ->
	collect result expr
    | AddrOf _
    | StartOf _ ->
	anything :: result
  in
  collect result (constFold true expr)


let embedGlobal channel = function
  | GVarDecl (var, _) ->
      let fields = collectVar [] var in
      List.iter
	(fun field -> ignore (fprintf channel "&%a\n" insert field))
	fields
  | GVar (var, {init = init}, _) ->
      begin
	let storage =
	  match var.vstorage with
	  | Extern -> '&'
	  | Static when var.vaddrof -> '&'
	  | Static -> '-'
	  | NoStorage | Register -> '+'
	in
	match isInterestingType var.vtype, collectVar [] var, init with
	| true, [receiver], Some (SingleInit init) ->
	    begin
	      match collectExpr [] init with
	      | [sender] ->
		  ignore (fprintf channel "%c%a\t%a\n" storage insert receiver insert sender)
	      | _ ->
		  ignore (fprintf channel "%c%a\n" storage insert receiver)
	    end
	| true, [single], None ->
	    ignore (fprintf channel "%c%a\t0\n" storage insert single)
	| _, fields, _ ->
	    List.iter
	      (fun field -> ignore (fprintf channel "%c%a\n" storage insert field))
	      fields
      end
  | _ ->
      ()


let simpleExpr expr =
  match collectExpr [] expr with
  | [single]
    when single != anything && single != arrayElem ->
      Some single
  | _ -> None


let rec simpleCondition =
  let isComparison = function
    | Lt | Gt | Le | Ge | Eq | Ne -> true
    | _ -> false
  in
  let negate = function
    | Lt -> Ge
    | Gt -> Le
    | Le -> Gt
    | Ge -> Lt
    | Eq -> Ne
    | Ne -> Eq
    | other ->
	ignore (bug "cannot negate operator \"%a\"" d_binop other);
	failwith "internal error"
  in
  function
    | BinOp(op, left, right, _)
      when isComparison op ->
	begin
	  match simpleExpr left, simpleExpr right with
	  | Some left, Some right ->
	      Some (op, left, right)
	  | _ ->
	      None
	end
    | UnOp(LNot, subcondition, _) ->
	begin
	  match simpleCondition subcondition with
	  | None -> None
	  | Some (op, left, right) ->
	      Some (negate op, left, right)
	end
    | other ->
	match simpleExpr other with
	| Some arg ->
	    Some (Ne, arg, num 0)
	| _ ->
	    None


class visitor file digest channel =
  object
    inherit FunctionBodyVisitor.visitor

    method vfunc fundec =
      ignore (fprintf channel "%s\n" fundec.svar.vname);
      let embedVars vars =
	let embedVar var =
	  let storage = if var.vaddrof then (chr '&') else nil in
	  let fields = collectVar [] var in
	  List.iter
	    (fun field -> ignore (fprintf channel "%a%a\n" insert storage insert field))
	    fields;
	in
	List.iter embedVar vars;
	output_char channel '\n'
      in
      embedVars fundec.sformals;
      embedVars fundec.slocals;
      ChangeDoChildrenPost (fundec, fun _ -> output_char channel '\n'; fundec)

    method vstmt statement =
      let flag, args =
	let noop = '~', [] in
	match statement.skind with
	| Return (Some sender, _) ->
	    begin
	      match collectExpr [] sender with
	      | [sender] -> '<', [sender]
	      | _ -> noop
	    end

	| Instr [Set (receiver, sender, _)] ->
	    let receivers = collectLval [] receiver in
	    let senders = collectExpr [] sender in
	    let folder args receiver sender =
	      receiver :: sender :: args
	    in
	    let args =
	      try
		List.fold_left2 folder [] receivers senders
	      with Invalid_argument _ ->
		ignore (bug "mismatched list lengths in assignment:\nreceivers:\t%a\t[%a]\nsenders:\t%a\t[%a]\n"
			  d_lval receiver
			  (d_list ", " insert) receivers
			  d_exp sender
			  (d_list ", " insert) senders);
		failwith "internal error"
	    in
	    '=', args

	| Instr [Call (receiver, _, senders, _)] ->
	    let receiver = match receiver with
	    | None -> chr '.'
	    | Some receiver ->
		match collectLval [] receiver with
		| [receiver] -> receiver
		| _ -> chr '.'
	    in
	    let senders = List.fold_right
		(fun sender senders ->
		  collectExpr senders sender)
		senders []
	    in
	    '>', receiver :: senders

	| Instr [Asm (_, _, receivers, _, clobbers, _)] ->
	    let receivers =
	      if List.mem "memory" clobbers then
		[chr '!']
	      else
		List.fold_left
		  (fun receivers (_, _, receiver) ->
		    collectLval receivers receiver)
		  [] receivers
	    in
	    '!', receivers

	| Instr [] ->
	    noop

	| Instr _ ->
	    ignore (bug "instr should have been atomized");
	    failwith "internal error"

	| If (condition, _, _, _) ->
	    begin
	      match simpleCondition condition with
	      | None -> noop
	      | Some (op, left, right) ->
		  '?', [d_binop () op; left; right]
	    end

	| _ ->
	    noop
      in
      ignore (fprintf channel "%c%a\n" flag (d_list "\t" insert) args);
      DoChildren

  end


let visit file digest =
  if !saveDataflow <> "" then
    TestHarness.time "saving dataflow information"
      (fun () ->
	let channel = open_out !saveDataflow in
	Printf.fprintf channel
	  "*\tdataflow\t0.2\n%s\n"
	  (Digest.to_hex (Lazy.force digest));

	iterGlobals file (embedGlobal channel);
	output_char channel '\n';

	let visitor = new visitor file digest channel in
	visitCilFileSameGlobals (visitor :> cilVisitor) file;
	output_char channel '\n';
	close_out channel)
