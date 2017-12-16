open Cil


class type c =
  object
    method findAllSites : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end
