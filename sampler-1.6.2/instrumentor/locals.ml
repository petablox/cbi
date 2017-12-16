open Cil


let renameLocals =
  Options.registerBoolean
    ~flag:"rename-locals"
    ~desc:"uniquely rename local variables"
    ~ident:"RenameLocals"
    ~default:false


let rename =
  "renaming local variables",
  fun file ->
    if !renameLocals then
      let renamer fundec =
	let renameOne varinfo =
	  varinfo.vname <- fundec.svar.vname ^ "$" ^ varinfo.vname
	in
	List.iter renameOne fundec.sformals;
	List.iter renameOne fundec.slocals
      in
      Scanners.iterFuncs file renamer


let makeTempVar func ?(name = "__cil_tmp") =
  let scope = if !renameLocals then func.svar.vname ^ "$" else "" in
  let basis = scope ^ name in
  fun typ -> Cil.makeTempVar func ~name:basis typ
