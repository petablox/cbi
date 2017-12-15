open Cil


class c : fundec -> location ->
  object
    method fundec : fundec
    method inspiration : location
    method implementation : stmt

    method print : Pretty.doc list
  end


val print : out_channel -> Digest.t Lazy.t -> SchemeName.t -> c QueueClass.container -> unit
