open Cil


class patcher countdown =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      match stmt.skind with
      | Return (_, location) ->
	  let export = countdown#export location in
	  stmt.skind <- Block (mkBlock [mkStmtOneInstr export; mkStmt stmt.skind]);
	  SkipChildren

      | _ ->
	  DoChildren
  end


let patch {sbody = sbody} countdown =
  let visitor = new patcher countdown in
  ignore (visitCilBlock visitor sbody)
