class c : SiteRegistry.c -> Attributes.t ->
  object
    inherit SectionLoader.t
    method private printLine : filename:string -> unit:string -> scheme:string -> siteInfo:string -> raw:string -> unit
  end
