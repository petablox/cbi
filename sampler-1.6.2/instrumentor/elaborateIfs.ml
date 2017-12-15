open Cil


let elaborateBlock block =
  if block.bstmts = [] then
    block.bstmts <- [mkStmt (Instr [])]


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      begin
	match stmt.skind with
	| If (_, thenBlock, elseBlock, _) ->
	    elaborateBlock thenBlock;
	    elaborateBlock elseBlock
	| _ -> ()
      end;
      DoChildren
  end


let visit func =
  let visitor = new visitor in
  ignore (visitCilFunction visitor func)
