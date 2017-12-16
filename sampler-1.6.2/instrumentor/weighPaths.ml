open Cil
open Site
open Weight


class weightsMap = [t] StmtIdHash.c 0


let weigh func sites headers balanced =
  
  let siteMap = new StmtIdHash.c 0 in
  List.iter
    (fun site -> siteMap#add site.statement site.scale)
    sites;

  let cache = new weightsMap in

  let rec subweight succ =
    if List.mem succ headers then
      weightless
    else
      weight succ

  and weight node =
    try cache#find node with
      Not_found ->
	let me =
	  try { threshold = siteMap#find node; count = 1; }
	  with Not_found -> weightless
	in
	let children =
	  let subweights = List.map subweight node.succs in
	  let maximum = List.fold_left max weightless subweights in

	  let matched sub =
	    maximum.threshold == sub.threshold
	  in
	  assert (not balanced || List.for_all matched subweights);
	  maximum
	in
	let total = sum me children in
	cache#add node total;
	total
  in

  CfgUtils.build func;

  let record header =
    ignore (weight header)
  in
  List.iter record func.sallstmts;
  cache
