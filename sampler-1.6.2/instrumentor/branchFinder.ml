open Cil


let postpatch replacement statement =
  statement.skind <- replacement;
  statement


class visitor file =
  let marker = Blast.predicateMarker2 file in
  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method vstmt stmt =
	match stmt.skind with
	| If (predicate, thenClause, elseClause, location)
	  when self#includedStatement stmt ->
	    let predTemp = var (Locals.makeTempVar func (typeOf predicate)) in
	    let predLval = Lval predTemp in
	    let selector = BinOp (Ne, predLval, zero, intType) in
	    let siteInfo = new ExprSiteInfo.c func location predicate in
	    let decide = mkStmtOneInstr (Set (predTemp, predicate, location)) in
	    let bump, siteId = tuples#addSiteExpr siteInfo selector in
	    let marker = marker siteId predLval location in
	    let branch = mkStmt (If (predLval, thenClause, elseClause, location)) in
	    let replacement = Block (mkBlock [decide; bump; marker; branch]) in
	    ChangeDoChildrenPost (stmt, postpatch replacement)

	| _ ->
	    DoChildren
    end
