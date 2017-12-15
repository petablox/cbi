open Cil


class type filter =
  object
    inherit Clude.filter

    method collectPragmas : file -> unit
  end


val filter : filter
