open Cil
open Printf


class printNodes =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt statement =
      ignore (Pretty.printf "  n%d [label = \"%s\"];@!"
		statement.sid
		(Utils.stmt_describe statement.skind));
      DoChildren
  end


class printEdges =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt statement =
      let printEdge succ =
	printf "  n%d -> n%d;\n" statement.sid succ.sid
      in
      List.iter printEdge statement.succs;
      DoChildren
  end


let process filename =
  let file = Frontc.parse filename () in
  let action func =
    CfgUtils.build func;
    printf "digraph %s {\n" func.svar.vname;
    ignore (visitCilFunction (new printNodes) func);
    ignore (visitCilFunction (new printEdges) func);
    print_endline "}"
  in
  Scanners.iterFuncs file action

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
