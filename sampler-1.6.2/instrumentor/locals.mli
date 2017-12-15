open Cil


val rename : Phase.phase

val makeTempVar : fundec -> ?name:string -> typ -> varinfo