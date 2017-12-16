open Cil
open Interesting
open SchemeName


let name = {
  flag = "scalar-pairs";
  prefix = "scalarPairs";
  ident = "ScalarPairs";
}


class c impls file : Scheme.c =
  object
    val tuples = new Counters.manager name file

    val constants = Constants.collect file
    val mutable globals = []

    method findAllSites =
      let impls = Lazy.force impls in
      TestHarness.time ("finding " ^ name.flag ^ " sites")
	(fun () ->
	  let scanner = function
	    | GVar (varinfo, _, _)
	    | GVarDecl (varinfo, _)
	      when isInterestingVar isDiscreteType varinfo ->
		globals <- varinfo :: globals
	    | GFun (func, _) ->
		let finder = new ScalarPairFinder.visitor constants globals tuples impls func in
		ignore (Cil.visitCilFunction finder func)
	    | _ ->
		()
	  in
	  iterGlobals file scanner);
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory impls = SchemeFactory.build name (new c impls)
