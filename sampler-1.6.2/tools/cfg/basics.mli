val sequence : ('a Stream.t -> unit) -> ('a Stream.t -> 'b) -> ('a Stream.t -> 'b list)
val sequenceLine : (char Stream.t -> 'b) -> (char Stream.t -> 'b list)
val sequenceTab : (char Stream.t -> 'b) -> (char Stream.t -> 'b list)

val wordLine : char Stream.t -> string
val wordTab : char Stream.t -> string

val integerLine : char Stream.t -> int
val integerTab : char Stream.t -> int
