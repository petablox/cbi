open Cil
open InterestingReturn


class visitor (tuples : Counters.manager) func =
  object (self)
    inherit SiteFinder.visitor

    method vfunc func =
      if self#includedFunction func then
	begin
	  StoreReturns.visit func;
	  DoChildren
	end
      else
	SkipChildren

    method vstmt stmt =
      match IsolateInstructions.isolated stmt with
      | Some (Call (Some result, callee, _, location))
	when self#includedStatement stmt
	    && isInterestingCallee callee ->
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    begin
	      let exp = Lval result in
	      let compare op = BinOp (op, exp, zero, intType) in
	      let selector = BinOp (PlusA, compare Gt, compare Ge, intType) in
	      let siteInfo = new ExprSiteInfo.c func location callee in
	      let bump, _ = tuples#addSiteExpr siteInfo selector in
	      stmt.skind <- Block (mkBlock [mkStmt stmt.skind; bump]);
	    end;
	  SkipChildren

      | _ ->
	  DoChildren
  end
