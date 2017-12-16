open Cil


type builder = location -> label


let build prefix =
  let nextId = ref 0 in
  fun location ->
    let name = Printf.sprintf "%s_%d" prefix !nextId in
    incr nextId;
    Label (name, location, false)


let hasGotoLabel statement =
  let isGotoLabel = function
    | Label _ -> true
    | _ -> false
  in
  List.exists isGotoLabel statement.labels


let buildGoto builder statement location =
  if not (hasGotoLabel statement) then
    statement.labels <- builder (get_stmtLoc statement.skind) :: statement.labels;
  Goto (ref statement, location)
