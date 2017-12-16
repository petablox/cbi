open Cil


exception Missing of string


let find name file =

  let rec findAmong = function
    | GFun ({svar = {vname = vname} as varinfo}, _) :: _
      when vname = name ->
	varinfo
    | GFun ({svar = {vname = vname; vinline = true} as varinfo}, _) :: _
      when vname = name ^ "__extinline" ->
	varinfo
    | GVarDecl ({vname = vname; vtype = TFun _} as varinfo, _) :: _
      when vname = name ->
	varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing name)
  in

  findAmong file.globals


let findDefinition name file =

  let rec findAmong = function
    | GFun ({svar = {vname = vname}} as fundec, _) :: _
      when vname = name ->
	fundec
    | GFun ({svar = {vname = vname; vinline = true}} as fundec, _) :: _
      when vname = name ^ "__extinline" ->
	fundec
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing name)
  in

  findAmong file.globals
