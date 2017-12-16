open Cil


let isInterestingCallee = function
  | Lval (Var {vname = "__builtin_constant_p"}, NoOffset) ->
      false
  | _ ->
      true


let isInterestingType resultType =
  match unrollType resultType with
  | TInt _
  | TEnum _
  | TPtr _ ->
      true
  | _ ->
      false
