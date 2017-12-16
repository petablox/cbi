open Cil


exception Found


let visit file digest =
  try
    let initinfo = FindGlobal.findInit "cbi_unitSignature" file in
    let signature = Lazy.force digest in
    let expr = mkString signature in
    initinfo.init <- Some (SingleInit expr)
  with
    Missing.Missing _ -> ()
