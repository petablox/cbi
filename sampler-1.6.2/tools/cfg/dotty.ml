open Known
open Types


let hash = Hashtbl.hash


let dump sink objects =
  let stubObject obj =
    let stubCompilation comp =
      let stubFunction func =
	let stubNode node =
	  match node.callees with
	  | Unknown ->
	      Printf.fprintf sink "\t\t\"???\" [shape=box];\n"
	  | Known callees ->
	      let stubCallee = function
		| Raw symbol ->
		    Printf.fprintf sink "\t\t\"%s()\" [shape=box];\n" symbol
		| Resolved _ ->
		    ()
	      in
	      List.iter stubCallee callees;
	in
	Array.iter stubNode func.nodes
      in
      List.iter stubFunction comp.functions
    in
    List.iter stubCompilation obj.compilations
  in

  let dumpObject obj =
    let dumpCompilation comp =
      let dumpFunction func =
	let dumpNode node =
	  Printf.fprintf sink "\t\t\t\t%d;\n" node.nid;
	  begin
	    match node.successors with
	    | [] ->
		()
	    | successors ->
		let dumpSucc succ =
		  Printf.fprintf sink " %d;" succ.nid
		in
		Printf.fprintf sink "\t\t\t\t%d -> {" node.nid;
		List.iter dumpSucc successors;
		Printf.fprintf sink " }\n"
	  end;
	  match node.callees with
	  | Unknown ->
	      Printf.fprintf sink "\t\t\t\t%d -> \"???\" [style=dotted];\n" node.nid
	  | Known callees ->
	      let dumpCallee = function
		| Raw symbol ->
		    Printf.fprintf sink "\t\t\t\t%d -> \"%s()\" [style=dotted];\n" node.nid symbol
		| Resolved func ->
		    Printf.fprintf sink "\t\t\t\t%d -> %d [style=dotted, lhead=cluster_%d];\n" node.nid func.nodes.(0).nid func.fid
	      in
	      List.iter dumpCallee callees;
	in
	Printf.fprintf sink "\t\t\tsubgraph cluster_%d {\n" func.fid;
	Printf.fprintf sink "\t\t\t\tlabel=\"%s()\";\n" func.name;
	Printf.fprintf sink "\t\t\t\t%d [shape=diamond];\n" func.nodes.(0).nid;
	Array.iter dumpNode func.nodes;
	Printf.fprintf sink "\t\t\t}\n";
      in
      Printf.fprintf sink "\t\tsubgraph \"cluster %s %s\" {\n" obj.objectName comp.sourceName;
      Printf.fprintf sink "\t\t\tlabel=\"%s\";\n" comp.sourceName;
      List.iter dumpFunction comp.functions;
      Printf.fprintf sink "\t\t}\n"
    in
    Printf.fprintf sink "\tsubgraph \"cluster %s\" {\n" obj.objectName;
    Printf.fprintf sink "\t\tlabel=\"%s\";\n" obj.objectName;
    List.iter dumpCompilation obj.compilations;
    Printf.fprintf sink "\t}\n"
  in

  Printf.fprintf sink "digraph CFG {\n";
  Printf.fprintf sink "\tcompound=true;\n";
  Printf.fprintf sink "\tsubgraph cluster_stubs {\n";
  Printf.fprintf sink "\t\tlabel=stubs\n";
  List.iter stubObject objects;
  Printf.fprintf sink "\t}\n";
  List.iter dumpObject objects;
  Printf.fprintf sink "}\n";
