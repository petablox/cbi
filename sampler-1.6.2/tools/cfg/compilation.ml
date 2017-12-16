open Basics


type result = Function.result list * Symtab.t


let parse objKey =
  let version =
    parser
	[< ''*'; ''\t'; ''0'; ''.'; ''1'; ''\n' >] ->
	  ()
  in

  let name = wordLine in

  let signature =
    let hex = parser [< ''0' .. '9' | 'a' .. 'f' as digit >] -> digit in
    parser
	[<
	  hex_00 = hex; hex_01 = hex; hex_02 = hex; hex_03 = hex;
	  hex_04 = hex; hex_05 = hex; hex_06 = hex; hex_07 = hex;
	  hex_08 = hex; hex_09 = hex; hex_10 = hex; hex_11 = hex;
	  hex_12 = hex; hex_13 = hex; hex_14 = hex; hex_15 = hex;
	  hex_16 = hex; hex_17 = hex; hex_18 = hex; hex_19 = hex;
	  hex_20 = hex; hex_21 = hex; hex_22 = hex; hex_23 = hex;
	  hex_24 = hex; hex_25 = hex; hex_26 = hex; hex_27 = hex;
	  hex_28 = hex; hex_29 = hex; hex_30 = hex; hex_31 = hex;
	  ''\n'
	    >]
	->
	  Printf.sprintf
	    "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c"
	    hex_00 hex_01 hex_02 hex_03 hex_04 hex_05 hex_06 hex_07
	    hex_08 hex_09 hex_10 hex_11 hex_12 hex_13 hex_14 hex_15
	    hex_16 hex_17 hex_18 hex_19 hex_20 hex_21 hex_22 hex_23
	    hex_24 hex_25 hex_26 hex_27 hex_28 hex_29 hex_30 hex_31
  in

  fun stream ->
    let statics = new Symtab.t in
    let parse = parser
	[< _ = version;
	   name = name;
	   _ = signature;
	   functions = sequenceLine (Function.parse (objKey, name) statics) >]
	->
	  (functions, statics)
    in
    parse stream


let addNodes graph (functions, _) =
  List.iter (Function.addNodes graph) functions


let addEdges graph (functions, statics) =
  List.iter (Function.addEdges graph statics) functions
