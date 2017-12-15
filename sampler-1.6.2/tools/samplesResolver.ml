open Printf


class loader registry =
  object
    inherit TaggedLoader.t "samples"

    method private sectionHandler =
      new SectionResolver.c registry
  end


let read registry =
  (new loader registry)#readChannel
