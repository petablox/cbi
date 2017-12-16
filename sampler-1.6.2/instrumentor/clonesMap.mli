open Cil


type clonesMap = (stmt * stmt) array

val findCloneOf : clonesMap -> stmt -> stmt
