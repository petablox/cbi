type argspec = string * Arg.spec * string


val push : argspec -> unit

val argspecs : unit -> argspec list


val registerBoolean : flag:string -> desc:string -> ident:string -> default:bool -> bool ref
val registerString  : flag:string -> desc:string -> ident:string -> string ref
