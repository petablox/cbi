open Cil
open Interesting
open SchemeName


let name = {
  flag = "bounds";
  prefix = "bounds";
  ident = "Bounds";
}


class visitor =
  object
    inherit SkipVisitor.visitor

    method vglob = function
      | GFun (func, _) as global ->
	  let finder = new BoundFinder.visitor global func in
	  ignore (Cil.visitCilFunction (finder :> cilVisitor) func);
	  ChangeTo finder#globals
      | _ ->
	  SkipChildren
  end
      

class c file : Scheme.c =
  object
    initializer
      if Threads.enabled () then
	failwith "bounds scheme is not thread safe"

    method findAllSites =
      let visitor = new visitor in
      ignore (Cil.visitCilFile visitor file);
      BoundManager.patch file

    method saveSiteInfo = BoundManager.saveSiteInfo name
  end


let factory = SchemeFactory.build name new c
