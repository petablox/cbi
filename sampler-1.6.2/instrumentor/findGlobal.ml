open Cil


let find name {globals = globals} =
  let rec findAmong = function
    | GVarDecl ({vtype = TFun _}, _) :: rest ->
	findAmong rest
    | GVarDecl ({vname = vname} as varinfo, _) :: _
      when vname = name ->
	varinfo
    | GVar ({vname = vname} as varinfo, _, _) :: _
      when vname = name ->
	varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing.Missing name)
  in
  findAmong globals


let findInit name {globals = globals} =
  let rec findAmong = function
    | GVar ({vname = vname}, initinfo, _) :: _
      when vname = name ->
	initinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing.Missing name)
  in
  findAmong globals
