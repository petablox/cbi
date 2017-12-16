open Cil


let cloneLabel = function
  | Label (name, location, fromSource) ->
      Label (name ^ "__dup", location, fromSource)
  | other -> other


(**********************************************************************)


class visitor pairs =
  object (self)
    inherit FunctionBodyVisitor.visitor

    method private fixup statement =
      begin
	assert (statement == snd pairs.(statement.sid));
	match statement.skind with
	| Switch (expression, body, cases, location) ->
	    let clonedCases =
	      let mapper case =
		assert (case == fst pairs.(case.sid));
		snd pairs.(case.sid)
	      in
	      List.map mapper cases
	    in
	    statement.skind <- Switch (expression, body, clonedCases, location)
	| _ ->
	    ()
      end;
      statement

    method vstmt stmt =
      let clone = { stmt with labels = mapNoCopy cloneLabel stmt.labels } in
      assert (stmt.sid >= 0);
      pairs.(stmt.sid) <- (stmt, clone);
      ChangeDoChildrenPost (clone, self#fixup)
  end


let duplicateBody fundec =
  match fundec.smaxstmtid with
  | None ->
      failwith "no maximum statement id; call CfgUtils.enumerate before duplicating"
  | Some max ->
      let pairs = Array.make max (dummyStmt, dummyStmt) in
      let visitor = new visitor pairs in
      let clone = visitCilBlock visitor fundec.sbody in
      (fundec.sbody, clone, pairs)
