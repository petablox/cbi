open Cil


type info = { forward : stmt list; backward : stmt list }

val visit : fundec -> info
