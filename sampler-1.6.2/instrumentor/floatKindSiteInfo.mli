open Cil


type left = lval * string * string

class c : fundec -> location -> left -> SiteInfo.c
