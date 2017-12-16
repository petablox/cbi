class virtual t : string ->
  object
    method private virtual sectionHandler : Attributes.t -> SectionLoader.t
    method readChannel : in_channel -> unit
  end
