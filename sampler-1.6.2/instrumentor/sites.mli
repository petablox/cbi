open Cil


val registry : Site.t FunctionNameHash.c


val setScales : unit -> unit

val patch : ClonesMap.clonesMap -> Countdown.countdown -> Site.t -> unit
