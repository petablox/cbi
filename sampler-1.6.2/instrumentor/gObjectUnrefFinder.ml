open Cil


let postpatch replacement statement =
  statement.skind <- replacement;
  statement


class visitor file =
  let classifier = Lval (var (FindFunction.find "cbi_gObjectUnrefClassify" file)) in
  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method vstmt stmt =
	match stmt.skind with
	| Instr [Call (_, Lval (Var {vname = "g_object_unref"}, NoOffset), [chaff], location)]
	  when self#includedStatement stmt ->
	    let slot = var (makeTempVar func uintType) in
	    let classify = Call (Some slot, classifier, [chaff], location) in
	    let selector = Lval slot in
	    let siteInfo = new ExprSiteInfo.c func location chaff in
	    let bump, _ = tuples#addSiteExpr siteInfo selector in
	    let replacement = Block (mkBlock [mkStmtOneInstr classify;
					      bump;
					      mkStmt stmt.skind])
	    in
	    stmt.skind <- replacement;
	    SkipChildren

	| _ ->
	    DoChildren
    end
