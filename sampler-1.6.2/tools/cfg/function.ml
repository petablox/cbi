open Basics
open Types.Function


type result = key * data


let parse compKey statics =
  let linkage = parser
    | [< ''-' >] -> Static
    | [< ''+' >] -> Extern
  in

  let name = wordTab in
  let location = Location.parse in
  let nodes = sequenceLine Statement.parse in

  parser
      [< linkage = linkage; ''\t'; name = name; location = location; nodes = nodes >] ->

	let nodes = Array.of_list nodes in
	let returns =
	  let accumulator = ref [] in
	  let filter id data =
	    if Statement.isReturn data then
	      accumulator := id :: !accumulator
	  in
	  Array.iteri filter nodes;
	  !accumulator
	in

	let data = {
	  location = location;
	  nodes = nodes;
	  returns = returns;
	} in

	let funcKey = (compKey, name) in
	let result = (funcKey, data) in

	(* register function in symbol tables *)
	statics#add name result;
	if linkage == Extern then
	  Symtab.externs#add name result;

	(* return to caller *)
	result


let addNodes graph (key, data) =
  let iterator slot =
    let nodeKey = (key, slot) in
    Statement.addNodes graph nodeKey
  in
  Array.iteri iterator data.nodes


let addEdges graph statics (key, data) =
  let iterator slot =
    let nodeKey = (key, slot) in
    Statement.addEdges graph statics nodeKey
  in
  Array.iteri iterator data.nodes
