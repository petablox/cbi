open Cil
open Pretty

let instr_what = function
  | Set _ -> "Set"
  | Call _ -> "Call"
  | Asm _ -> "Asm"

let stmt_what = function
  | Instr instrs -> Printf.sprintf "Instr × %i" (List.length instrs)
  | Return _ -> "Return"
  | Goto _ -> "Goto"
  | Break _ -> "Break"
  | Continue _ -> "Continue"
  | If _ -> "If"
  | Switch _ -> "Switch"
  | Loop _ -> "Loop"
  | Block {bstmts = bstmts} -> Printf.sprintf "Block × %i" (List.length bstmts)
  | TryFinally _ -> "TryFinally"
  | TryExcept _ -> "TryExcept"

let stmt_describe stmt =
  let where = get_stmtLoc stmt in
  Printf.sprintf "%s:%i: %s" where.file where.line (stmt_what stmt)
    
let d_stmt _ stmt =
  dprintf "%a: CFG #%i: %s" d_loc (get_stmtLoc stmt.skind) stmt.sid (stmt_what stmt.skind)
    
let d_stmts _ stmts =
  seq line (d_stmt ()) stmts
    
let print_stmts stmts =
  fprint stdout 80 (d_stmts () stmts)
    
let warn stmt message =
  ignore(fprintf stderr "%a: %s\n" d_stmt stmt message)


let d_label () = function
  | Label (name, _, _) ->
      text name
  | Case (expr, _) ->
      text "case " ++ d_exp () expr
  | Default _ ->
      text "default"

let d_labels () labels =
  seq
    ~sep:(text "; ")
    ~doit:(d_label ())
    ~elements:labels


let d_preds () {preds = preds} =
  seq
    ~sep:(text "; ")
    ~doit:(fun stmt -> num stmt.sid)
    ~elements:preds


let d_succs () {succs = succs} =
  seq
    ~sep:(text "; ")
    ~doit:(fun stmt -> num stmt.sid)
    ~elements:succs
