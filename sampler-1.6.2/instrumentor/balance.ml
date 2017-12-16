open Cil
open Weight


type t = stmt list


let fallthroughLabel = Labels.build "fallthrough"

let counterweightLabel = Labels.build "counterweight"


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      begin
	match stmt.skind with
	| Switch (expr, block, cases, location) ->
	    if not (CfgUtils.hasDefault cases) then
	      let default = mkEmptyStmt () in
	      default.labels <- [Default location];
	      let break = mkStmt (Break location) in
	      block.bstmts <- default :: break :: block.bstmts;
	      let cases = default :: cases in
	      stmt.skind <- Switch (expr, block, cases, location)
	| _ ->
	    ()
      end;
      DoChildren

    method vfunc func =
      CfgUtils.build func;
      DoChildren
  end


let addDefaultCases func =
  ignore (visitCilFunction (new visitor) func)


let prepatchSplits func =
  let isSplit = function
    | { skind = If (_, thenBlock, elseBlock, _) } ->
	(* make space for possible future counterweights *)
	let reserveSpace block =
	  block.bstmts <- mkEmptyStmt () :: block.bstmts
	in
	reserveSpace thenBlock;
	reserveSpace elseBlock;
	true

    | { skind = Switch (expr, block, cases, location) } as stmt ->
	(* turn case fallthroughs into explicit gotos *)
	let cases =
	  let elaborateFallthrough case =
	    let hasFallthrough =
	      let isFallthrough pred =
		match pred.skind with
		| Goto _ -> false
		| _ -> pred != stmt
	      in
	      List.exists isFallthrough case.preds
	    in
	    if hasFallthrough then
	      let location = get_stmtLoc case.skind in
	      let switchTarget = mkStmt case.skind in
	      switchTarget.labels <- case.labels;
	      let explicitGoto = mkStmt (Labels.buildGoto fallthroughLabel switchTarget location) in
	      case.labels <- [];
	      case.skind <- Block (mkBlock [explicitGoto; switchTarget]);
	      switchTarget
	    else
	      case
	  in
	  List.map elaborateFallthrough cases
	in

	stmt.skind <- Switch (expr, block, cases, location);
	true

    | { succs = [] }
    | { succs = [_] } ->
	false

    | stmt ->
	ignore (bug "%s: unexpected kind of multi-successor statement" (Utils.stmt_describe stmt.skind));
	failwith "internal error"
  in
  CfgUtils.build func;
  List.filter isSplit func.sallstmts


let prepatch func =
  if !BalancePaths.balancePaths then
    begin
      addDefaultCases func;
      prepatchSplits func
    end
  else
    []


let patch func splits weights =
  let weightOf stmt = (weights#find stmt).threshold in

  let makeCounterweight () =
    let dummy = mkEmptyStmt () in
    dummy.labels <- [counterweightLabel locUnknown];
    Sites.registry#add func (Site.build dummy);
    dummy
  in

  let prependCounterweights stmt =
    let selfWeight = weightOf stmt in
    fun successor tail ->
      assert (List.memq successor stmt.succs);
      let succWeight = weightOf successor in
      assert (succWeight <= selfWeight);
      let result = ref tail in
      for prepend = succWeight + 1 to selfWeight do
	result := makeCounterweight () :: !result
      done;
      !result
  in

  let patchOneSplit stmt =
    match stmt.skind with
    | If (_, thenBlock, elseBlock, _) ->
	let prependCounterweights = prependCounterweights stmt in
	let balanceClause clause =
	  clause.bstmts <- prependCounterweights (List.hd clause.bstmts) clause.bstmts
	in
	balanceClause thenBlock;
	balanceClause elseBlock

    | Switch (_, _, cases, _) ->
	let prependCounterweights = prependCounterweights stmt in
	let balanceCase case =
	  let switchLabels, gotoLabels =
	    let isCaseLabel = function
	      | Case _
	      | Default _ ->
		  true
	      | Label _ ->
		  false
	    in
	    List.partition isCaseLabel case.labels
	  in
	  assert (switchLabels <> []);
	  case.labels <- [];

	  let gotoTarget = mkStmt case.skind in
	  gotoTarget.labels <- gotoLabels;
	  let balanced = prependCounterweights case [gotoTarget] in
	  case.skind <- Block (mkBlock balanced);
	  case.labels <- switchLabels;

	  let redirectGoto pred =
	    match pred.skind with
	    | Goto (target, _) ->
		assert (!target == case);
		target := gotoTarget
	    | Switch _ ->
		assert (pred == stmt)
	    | other ->
		currentLoc := get_stmtLoc other;
		ignore (bug "unexpected predecessor kind (%s) for elaborated case@!  @[switch labels: [%a]@!goto labels: [%a]@!@]"
			  (Utils.stmt_what other)
			  Utils.d_labels switchLabels
			  Utils.d_labels gotoLabels);
		failwith "internal error"
	  in
	  List.iter redirectGoto case.preds
	in
	List.iter balanceCase cases

    | other ->
	currentLoc := get_stmtLoc other;
	ignore (bug "unexpected statment kind (%s) on path balancing split list"
		  (Utils.stmt_what other));
	failwith "internal error"
  in
  List.iter patchOneSplit splits
