open Cil


let postBlock block =
  let rec merge = function
    | [] ->
	[]
    | { skind = Instr []; labels = [] } :: rest ->
	merge rest
    | { skind = Instr instrs; } as first :: { skind = Instr instrs'; labels = [] } :: rest ->
	first.skind <- Instr (instrs @ instrs');
	merge (first :: rest)
    | { skind = Block { bstmts = stmts; battrs = [] }; labels = [] } :: rest ->
	merge (stmts @ rest)
    | { skind = Goto (destination, _); labels = [] } :: ((destination' :: _) as rest)
      when destination' == !destination ->
	merge rest
    | first :: rest ->
	first :: merge rest
  in
  block.bstmts <- merge block.bstmts;
  block


let postStmt stmt =
  match stmt.skind with
  | Block { bstmts = [singleton] } ->
      assert (stmt.labels == []);
      singleton
  | _ ->
      stmt


class visitor =
  object
    inherit FunctionBodyVisitor.visitor
	
    method vblock block =
      ChangeDoChildrenPost (block, postBlock)

    method vstmt stmt =
      match stmt with
      | { skind = Block { battrs = [] }; labels = [] } ->
	  ChangeDoChildrenPost (stmt, postStmt)
      | _ ->
	  DoChildren
  end


let visit func =
  ignore (visitCilFunction new visitor func)
