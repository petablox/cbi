open Basics
open FlowGraph


type site = Types.Function.extension * Types.Statement.extension


exception Eliminate of site * site


let graph = Args.process ()


let sites =
  let parseOne = parser
      [< func = wordTab; id = integerLine >] ->
	(func, id)
  in
  let parseAll = sequence Stream.empty parseOne in

  let list = parseAll (Stream.of_channel stdin) in
  let table = new HashClass.c 2 in

  let insert ((func, id) as site) =
    try
      ignore (Statement.findNode site);
      table#add site ()
    with Not_found ->
      Printf.eprintf "warning: invalid site: %s:%d\n" func id
  in
  List.iter insert list;
  table


let eliminate description follow sites =
  let reach =
    Memoize.memoize (fun (a, b) ->
      let aNode = Statement.findNode a in
      let bNode = Statement.findNode b in
      Transitive.reach ignore follow aNode bNode)
  in

  let iteration progress =
    let compare a b =
      let (aFunc, aId) = a in
      let (bFunc, bId) = b in
      let description = Printf.sprintf "reach %s:%d <-?-> %s:%d" aFunc aId bFunc bId in
      Phase.time description (fun () ->
	match (reach (a, b), reach (b, a)) with
	| (false, true) ->
	    raise (Eliminate (a, b))
	| (true, false) ->
	    raise (Eliminate (b, a))
	| (false, false)
	| (true, true) ->
	    ())
    in
    try
      sites#iter (fun a () ->
	sites#iter (fun b () ->
	  compare a b))
    with Eliminate ((iFunc, iId) as inferior, (sFunc, sId)) ->
      sites#remove inferior;
      Printf.eprintf "eliminate %s:%d as inferior to %s:%d\n%!"
	iFunc iId sFunc sId;
      progress := true
  in

  Fixpoint.compute iteration;

  sites#iter (fun (func, id) () ->
    Printf.printf "%s\t%s\t%d\n%!" description func id)


;;


let succ = sites in
let pred = sites#copy in

eliminate "succ" graph#succ succ;
eliminate "pred" graph#pred pred
