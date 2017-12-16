open Printf


class resolver registry attributes =
  object
    val timing = attributes#find "when"

    inherit SectionResolver.c registry attributes

    method private printLine ~filename ~unit ~scheme ~siteInfo ~raw =
      printf "%s\t%s\t%s\t%s\t%s\t%s\n" raw filename unit scheme timing siteInfo
  end


class loader registry =
  object
    inherit TaggedLoader.t "timestamps"

    method private sectionHandler =
      new resolver registry
  end


let read registry =
  (new loader registry)#readChannel
