open Cil


type info = {
    location : location;
    jump : stmt;
    target : stmt;
  }


let makeLabel =
  let nextLabelId = ref 0 in
  fun location ->
    let labelId = string_of_int !nextLabelId in
    incr nextLabelId;
    Label ("postcall_" ^ labelId, location, false)


class visitor isWeighty countdown =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable result = []
    method result = result

    method vstmt stmt =
      match IsolateInstructions.isolated stmt with
      | Some (Call (_, Lval callee, _, location) as call)
	when isWeighty callee ->
	  let info = {location = location;
		      jump = mkEmptyStmt ();
		      target = mkEmptyStmt ()}
	  in
	  info.target.labels <- [makeLabel location];
	  stmt.skind <- Block (mkBlock [mkStmt (Instr [countdown#export location;
						       call;
						       countdown#import location]);
					info.jump;
					info.target]);
	  result <- info :: result;
	  SkipChildren

      | _ ->
	  DoChildren
  end


let prepatch isWeighty func countdown =
  let visitor = new visitor isWeighty countdown in
  ignore (visitCilFunction (visitor :> cilVisitor) func);
  visitor#result


let jumpify =
  let patchOne info =
    info.jump.skind <- Goto (ref info.target, info.location);
    info.jump
  in
  List.map patchOne
