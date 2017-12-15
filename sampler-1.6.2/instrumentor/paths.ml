open Pretty


let cwd = text (Sys.getcwd ())


let relativePaths =
  Options.registerBoolean
    ~flag:"relative-paths"
    ~desc:"store relative source paths in static site information"
    ~ident:"RelativePaths"
    ~default:false


let normalize { Cil.file = given } =
  let givenDoc = text given in
  if not !relativePaths && Filename.is_relative given then
    cwd ++ chr '/' ++ givenDoc
  else
    givenDoc
