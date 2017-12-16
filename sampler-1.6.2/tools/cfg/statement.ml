open Basics
open FlowGraph
open Known
open Types.Statement


type result = data


let nodeCount = ref 0
let edgeCount = ref 0


let parse =
  let location = Location.parse in

  let successors =
    let successor stream =
      let result = integerTab stream in
      incr edgeCount;
      result
    in
    sequenceLine successor
  in

  let callees =
    let unknown =
      parser
	  [< ''?'; ''?'; ''?'; ''\n' >] -> ()
    in
    let known =
      let callee = wordTab in
      sequenceLine callee
    in
    parser
      | [< _ = unknown >] -> Unknown
      | [< callees = known >] -> Known callees
  in

  parser
      [< location = location;
	 successors = successors;
	 callees = callees >]
      ->
	nodeCount := !nodeCount + 2;
	incr edgeCount;
	{ location = location;
	  successors = successors;
	  callees = callees;
	}


let isReturn node =
  node.successors = []


let registry = new HashClass.c 0


let findNode subkey =
  match registry#findAll subkey with
  | [] -> raise Not_found
  | [singleton] -> singleton
  | first :: _ ->
      let (func, id) = subkey in
      Printf.eprintf "warning: multiple matches found for %s:%d\n" func id;
      first


let addNodes graph key data =
  graph#addNode (Before, key) data;
  graph#addNode (After, key) data;
  let ((_, func), id) = key in
  registry#add (func, id) (Before, key)


let addEdges graph statics ((func, _) as originKey) data =
  let addFlow destinationId =
    let destinationKey = (func, destinationId) in
    graph#addEdge (After, originKey) Flow (Before, destinationKey)
  in
  List.iter addFlow data.successors;

  let shortcut = ref false in

  begin
    match data.callees with
    | Unknown
    | Known [] ->
	shortcut := true

    | Known callees ->
	let addCall calleeName =
	  try
	    let callee =
	      try statics#find calleeName
	      with Not_found -> Symtab.externs#find calleeName
	    in

	    let entryNode = (fst callee, 0) in
	    graph#addEdge (Before, originKey) Call (Before, entryNode);

	    let addReturnEdge return =
	      graph#addEdge (After, (fst callee, return)) Return (After, originKey)
	    in
	    List.iter addReturnEdge (snd callee).Types.Function.returns

	  with Not_found ->
	    shortcut := true
	in
	List.iter addCall callees
  end;

  if !shortcut then
    graph#addEdge (Before, originKey) Flow (After, originKey)
