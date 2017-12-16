open Cil


class weightsMap : [Weight.t] StmtIdHash.c

val weigh : fundec -> Site.t list -> stmt list -> bool -> weightsMap
