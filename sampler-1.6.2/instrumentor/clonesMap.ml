open Cil


type clonesMap = (stmt * stmt) array


let findCloneOf pairs {sid = sid} =
  snd pairs.(sid)
