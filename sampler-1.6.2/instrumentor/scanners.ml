open Cil


let iterFuncs file action =
  let visitor = function
    | GFun (fundec, _) -> action fundec
    | _ -> ()
  in
  iterGlobals file visitor
