open Cil
open InterestingReturn


class visitor func =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt _ = DoChildren

    method vinst = function
      | Call (None, callee, args, location)
	when isInterestingCallee callee ->
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    let resultVar = Locals.makeTempVar func resultType in
	    let result = Some (var resultVar) in
	    ChangeTo [Call (result, callee, args, location)]
	  else
	    SkipChildren
      | _ ->
	  SkipChildren
  end


let visit func =
  let visitor = new visitor func in
  ignore (visitCilFunction visitor func)
