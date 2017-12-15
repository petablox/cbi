open Cil

type resolution = Unknown | Known of varinfo list

val analyze : file -> unit
val resolve : lval -> resolution
