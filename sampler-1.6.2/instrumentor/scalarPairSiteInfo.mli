open Cil


type left = lval * string * string
type right = Constant of exp | Variable of varinfo

class c : fundec -> location -> left -> right -> SiteInfo.c
