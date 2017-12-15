open Cil
open Interesting
open SchemeName


let name = {
  flag = "float-kinds";
  prefix = "floatKinds";
  ident = "FloatKinds";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file

    val classifier = FloatKindFinder.classifier file

    method findAllSites =
      TestHarness.time ("finding " ^ name.flag ^ " sites")
	(fun () ->
	  let scanner = function
	    | GFun (func, _) ->
		let finder = new FloatKindFinder.visitor classifier tuples func in
		ignore (Cil.visitCilFunction finder func)
	    | _ ->
		()
	  in
	  iterGlobals file scanner);
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory = SchemeFactory.build name new c
