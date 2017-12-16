class c (registry : SiteRegistry.c) (attributes : Attributes.t) =
  let unit = attributes#find "unit" in
  let scheme = attributes#find "scheme" in
  let (filename, sites) = registry#find (unit, scheme) in

  object (self)
    val mutable line = 0

    method private printLine ~filename ~unit ~scheme ~siteInfo ~raw =
      Printf.printf "%s\t%s\t%s\t%s\t%s\n" filename unit scheme siteInfo raw
      
    method readLine raw =
      let siteInfo = sites.(line) in
      self#printLine ~filename:filename ~unit:unit ~scheme:scheme ~siteInfo:siteInfo ~raw:raw;
      line <- line + 1

    method finish =
      if line <> Array.length sites then
	failwith "sites/samples line count mismatch"
  end
