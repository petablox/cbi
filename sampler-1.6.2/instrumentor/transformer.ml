open Calls
open Cil
open ClassifyJumps
open FuncInfo
open Weight


let visit file isWeightyCallee countdown =
  let visitFunction func =
    match Sites.registry#findAll func with
    | [] -> ()
    | sites ->
	let entry = mkStmt (Block func.sbody) in
	func.sbody <- mkBlock [entry];

	let countdown = countdown func in
	let afterCalls = WeightyCalls.prepatch isWeightyCallee func countdown in
	let splits = Balance.prepatch func in

	RemoveLoops.visit func;
	let jumps = ClassifyJumps.visit func in
	let callJumps = WeightyCalls.jumpify afterCalls in
	let backJumps = jumps.backward @ callJumps in
	let headers = entry :: backJumps in
	let weights = WeighPaths.weigh func sites headers false in

	let sites, weights =
	  if !BalancePaths.balancePaths then
	    begin
	      Balance.patch func splits weights;
	      CfgUtils.build func;
	      let sites = Sites.registry#findAll func in
	      let weights = WeighPaths.weigh func sites headers true in
	      sites, weights
	    end
	  else
	    sites, weights
	in

	let _, instrumented, clones = Duplicate.duplicateBody func in

	ForwardJumps.patch clones jumps.forward;
	BackwardJumps.patch clones weights countdown backJumps;
	FunctionEntry.patch func weights countdown instrumented;
	Returns.patch func countdown;
	List.iter (Sites.patch clones countdown) sites;

	if !Statistics.showStats then
	  begin
	    let siteCount = List.length sites in

	    let headerTotal, headerCount =
	      weights#fold
		(fun _ { threshold = threshold } (total, count) ->
		  if threshold == 0 then
		    (total, count)
		  else
		    (total + threshold, count + 1))
		(0, 0)
	    in
	    Printf.eprintf "stats: transform: %s has sites: %d sites, %d headers, %d total header weights\n"
	      func.svar.vname siteCount headerCount headerTotal;
	    countdown#printStats
	  end;

	FilterLabels.visit func
  in
  Scanners.iterFuncs file visitFunction
