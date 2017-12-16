open Cil
open Clude


class filter ~flag ~desc ~ident =
  object
    inherit Clude.filter ~flag:flag ~desc:desc ~ident:ident as super

    val pragmaExclusions = new StringHash.c 0

    method collectPragmas file =
      let iterator = function
	| GPragma (Attr ("sampler_exclude_function", [AStr name]), _) ->
	    pragmaExclusions#add name ()
	| _ -> ()
      in
      iterGlobals file iterator

    method included focus =
      if pragmaExclusions#mem focus then
	false
      else
	super#included focus
  end


let filter = new filter
    ~flag:"function"
    ~desc:"<function> instrument this function"
    ~ident:"FilterFunction"
