open Cil
open Interesting
open Pretty
open ScalarPairSiteInfo


let compareUninitialized =
  Options.registerBoolean
    ~flag:"compare-uninitialized"
    ~desc:"consider uninitialized variables in scalar-pairs comparisons"
    ~ident:"CompareUninitialized"
    ~default:false


let d_columns = seq ~sep:(chr '\t') ~doit:(fun doc -> doc)


let isInterestingVar  = isInterestingVar  isDiscreteType
let isInterestingLval = isInterestingLval isDiscreteType


class visitor (constants : Constants.collection) globals (tuples : Counters.manager) (implInfo : Implications.constantComparisonAccumulator) func =
  object (self)
    inherit SiteFinder.visitor

    val formals = List.filter isInterestingVar func.sformals
    val locals = List.filter isInterestingVar func.slocals

    method vfunc func =
      if self#includedFunction func then
	begin
	  if not !compareUninitialized then
	    begin
	      CfgUtils.build func;
	      Initialized.analyze func locals
	    end;
	  DoChildren
	end
      else
	SkipChildren

    method vstmt stmt =

      let build first left location (host, off) =
	let leftType = typeOfLval left in
	let leftTypeSig = typeSig leftType in
	let siteInfo = new ScalarPairSiteInfo.c func location (left, host, off) in

	let newLeft = var (Locals.makeTempVar func leftType) in
	let last = mkStmt (Instr [Set (left, Lval newLeft, location)]) in
	let statements = ref [last] in

	let selector right =
	  let compare op = BinOp (op, Lval newLeft, right, intType) in
	  BinOp (PlusA, compare Gt, compare Ge, intType)
	in

	let compareToVarMaybe right =
	  if leftTypeSig = typeSig right.vtype then
	    let selector = selector (Lval (var right)) in
	    let siteInfo = siteInfo (Variable right) in
	    let bump, _ = tuples#addSiteExpr siteInfo selector in
	    statements := bump :: !statements
	in

	let initializedLocals =
	  let isInitialized =
	    try Initialized.possibly stmt
	    with Not_found -> fun _ -> false
	  in
	  List.filter isInitialized locals
	in

	List.iter compareToVarMaybe globals;
	List.iter compareToVarMaybe formals;
	List.iter compareToVarMaybe initializedLocals;
	
	let constantsCount = ref 0 in
	let compareToConst right =
	  let selector = selector right in
	  let siteInfo = siteInfo (Constant right) in
	  let bump, id = tuples#addSiteExpr siteInfo selector in
          implInfo#addInfo (id, location, newLeft, (stripCasts right));
	  statements := bump :: !statements;
	  incr constantsCount
	in

	let iterConsts signed =
	  let kind = if signed then ILongLong else IULongLong in
	  let action right () =
	    compareToConst (kinteger64 kind right)
	  in
	  constants#iter action
	in

	begin
	  match unrollType leftType with
	  | TPtr _ ->
	      compareToConst (mkCast zero leftType)
	  | TInt (ikind, _) ->
	      iterConsts (isSigned ikind)
	  | TEnum _ ->
	      iterConsts true
	  | other ->
	      ignore (bug "unexpected left operand type: %a\n" d_type other)
	end;

	if !Statistics.showStats then
	  ignore (Pretty.eprintf "%t: stats: scalar-pairs: %d constants, %d globals, %d formals, %d initialized locals, %d uninitialized locals\n"
		    d_thisloc
		    !constantsCount
		    (List.length globals)
		    (List.length formals)
		    (List.length initializedLocals)
		    (List.length locals - List.length initializedLocals));


	let first = mkStmtOneInstr (first newLeft) in
	Block (mkBlock (first :: !statements))
      in

      match IsolateInstructions.isolated stmt with
      | Some (Set (left, expr, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Set (temp, expr, location)) in
		stmt.skind <- build replacement left location info;
	  end;
	  SkipChildren

      | Some (Call (Some left, callee, args, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Call (Some temp, callee, args, location)) in
		stmt.skind <- build replacement left location info;
	  end;
	  SkipChildren

      | _ ->
	  DoChildren
  end
