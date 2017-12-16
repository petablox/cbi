open Cil
open FuncInfo
open Scanners
open Str


let assumeWeightyExterns =
  Options.registerBoolean
    ~flag:"assume-weighty-externs"
    ~desc:"assume that functions defined elsewhere have sample sites"
    ~ident:"AssumeWeightyExterns"
    ~default:true

let assumeWeightyLibraries =
  Options.registerBoolean
    ~flag:"assume-weighty-libraries"
    ~desc:"assume that functions defined in libraries have sample sites"
    ~ident:"AssumeWeightyLibraries"
    ~default:false

let assumeWeightyInterns =
  Options.registerBoolean
    ~flag:"assume-weighty-interns"
    ~desc:"assume that functions defined here have sample sites"
    ~ident:"AssumeWeightyInterns"
    ~default:false

let debugWeighty =
  Options.registerBoolean
    ~flag:"debug-weighty"
    ~desc:"print extra debugging information during weighty function analysis"
    ~ident:""
    ~default:false


(**********************************************************************)


let hasDefinition file =
  let defined = new VariableNameHash.c 0 in
  let iterator func =
    defined#add func.svar ()
  in
  iterFuncs file iterator;
  defined#mem


let hasPragmaWeightless file =
  let assumed = new StringHash.c 0 in
  let iterator = function
    | GPragma (Attr ("sampler_assume_weightless", [AStr (funcname)]), location) ->
	assumed#add funcname ();
	if !debugWeighty then
	  ignore (Pretty.eprintf "%a: function %s is assumed weightless by pragma@!" d_loc location funcname)
    | _ -> ()
  in
  iterGlobals file iterator;
  fun callee -> assumed#mem callee.vname


let isWeightyLibrary =
  let pattern = regexp "^(bsearch|qsort)$|setjmp|longjmp" in
  fun varinfo -> string_match pattern varinfo.vname 0


let isBuiltin =
  let pattern = regexp "^__builtin_" in
  fun varinfo -> string_match pattern varinfo.vname 0


(**********************************************************************)


let isWeightyVarinfo hasDefinition hasPragmaWeightless weighty callee =
  if weighty#mem callee then
    true
  else if hasDefinition callee then
    !assumeWeightyInterns
  else if hasPragmaWeightless callee then
    false
  else if isWeightyLibrary callee then
    true
  else if Libraries.functions#mem callee.vname then
    !assumeWeightyLibraries
  else if isBuiltin callee then
    false
  else
    !assumeWeightyExterns


let isWeightyLval hasDefinition hasPragmaWeightless weighty lval =
  match Dynamic.resolve lval with
  | Dynamic.Unknown ->
      true
  | Dynamic.Known possibilities ->
    List.exists (isWeightyVarinfo hasDefinition hasPragmaWeightless weighty) possibilities


(**********************************************************************)


exception ContainsWeightyCall of location * lval


class visitor hasDefinition hasPragmaWeightless weighty =
  object
    inherit FunctionBodyVisitor.visitor

    method vfunc func =
      if weighty#mem func.svar then
	SkipChildren
      else
	DoChildren

    method vstmt _ = DoChildren

    method vinst instr =
      begin
	match instr with
	| Call (_, Lval lval, _, location)
	  when isWeightyLval hasDefinition hasPragmaWeightless weighty lval ->
	    raise (ContainsWeightyCall (location, lval))

	| Call (_, Lval _, _, _) ->
	    ()

	| Call (_, callee, _, _) ->
	    ignore (bug "unexpected non-lval callee: %a" d_exp callee);
	    failwith "internal error"

	| _ -> ()

      end;
      SkipChildren
  end


type tester = lval -> bool


let collect file =
  TestHarness.time "identifying weighty functions"
    (fun () ->
      let hasDefinition = hasDefinition file in
      let hasPragmaWeightless = hasPragmaWeightless file in
      let weighty = new VariableNameHash.c 0 in

      let prepopulate func =
	if !assumeWeightyInterns || Sites.registry#mem func then
	  begin
	    weighty#add func.svar ();
	    if !debugWeighty then
	      Printf.eprintf "function %s is weighty: has sites\n" func.svar.vname
	  end
      in
      Scanners.iterFuncs file prepopulate;

      let visitor = new visitor hasDefinition hasPragmaWeightless weighty in
      let refine madeProgress =
	let iterator func =
	  try
	    ignore (visitCilFunction visitor func)
	  with ContainsWeightyCall (location, callee) ->
	    weighty#add func.svar ();
	    madeProgress := true;
	    if !debugWeighty then
	      ignore (Pretty.eprintf "%a: function %s is weighty: has weighty call to %a@!"
			d_loc location func.svar.vname d_lval callee)
	in
	iterFuncs file iterator
      in
      Fixpoint.compute refine;

      let tester = isWeightyLval hasDefinition hasPragmaWeightless weighty in

      if !Statistics.showStats then
	begin
	  let numFuncs = ref 0 in
	  let numWeightless = ref 0 in
	  let iterator func =
	    incr numFuncs;
	    if not (tester (var func.svar)) then
	      incr numWeightless
	  in
	  iterFuncs file iterator;
	  Printf.eprintf "stats: weightless: %d functions, %d weightless\n" !numFuncs !numWeightless
	end;

      tester)
