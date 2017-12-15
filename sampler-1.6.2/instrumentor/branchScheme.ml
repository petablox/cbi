open SchemeName


let name = {
  flag = "branches";
  prefix = "branches";
  ident = "Branches";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file

    method private findAllSites =
      let finder = new BranchFinder.visitor file tuples in
      Scanners.iterFuncs file
	(fun func ->
	  let finder = finder func in
	  ignore (Cil.visitCilFunction finder func));
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory = SchemeFactory.build name new c
