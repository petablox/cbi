open Cil


type t

val prepatch : fundec -> t
val patch : fundec -> t -> WeighPaths.weightsMap -> unit
