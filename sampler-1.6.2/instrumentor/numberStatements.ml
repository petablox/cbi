open Cil


class visitor func =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable nextId = 0

    method vstmt statement =
      func.sallstmts <- statement :: func.sallstmts;
      statement.sid <- nextId;
      nextId <- nextId + 1;
      DoChildren

    method vfunc func =
      func.sallstmts <- [];
      let post func =
	func.smaxstmtid <- Some nextId;
	func
      in
      ChangeDoChildrenPost (func, post)
  end


let visit func =
  ignore (visitCilFunction (new visitor func) func)
