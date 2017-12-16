open Cil


type tester = lval -> bool

val collect : file -> tester
