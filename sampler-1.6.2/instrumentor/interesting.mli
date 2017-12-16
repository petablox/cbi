open Cil


val isDiscreteType : typ -> bool
val isFloatType    : typ -> bool

val isInterestingVar  : (typ -> bool) -> varinfo -> bool
val isInterestingLval : (typ -> bool) -> lval    -> (string * string) option
