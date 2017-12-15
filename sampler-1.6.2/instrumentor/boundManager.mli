open Cil


val register : (varinfo * varinfo) -> BoundSiteInfo.c -> unit
val patch : file -> unit
val saveSiteInfo : SchemeName.t -> Digest.t Lazy.t -> out_channel -> unit
