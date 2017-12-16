open SchemeName


type t = Cil.file -> Scheme.c


let build name factory =
  let active = Options.registerBoolean
      ~flag: ("scheme-" ^ name.flag)
      ~desc: ("enable " ^ name.flag ^ " instrumentation scheme")
      ~ident: ("Scheme" ^ name.ident)
      ~default: false
  in
  fun file ->
    if !active then factory file
    else NothingScheme.factory file
