open Cil


let assignAcrossPointer =
  Options.registerBoolean
    ~flag:"assign-across-pointer"
    ~desc:"instrument assignments across pointers"
    ~ident:"AssignAcrossPointer"
    ~default:false


let assignIntoField =
  Options.registerBoolean
    ~flag:"assign-into-field"
    ~desc:"instrument assignments into structure fields"
    ~ident:"AssignIntoField"
    ~default:false


let assignIntoIndex =
  Options.registerBoolean
    ~flag:"assign-into-index"
    ~desc:"instrument assignments into indexed array slots"
    ~ident:"AssignIntoIndex"
    ~default:false


let isDiscreteType typ =
  isIntegralType typ || isPointerType typ


let isFloatType typ =
  match unrollType typ with
  | TFloat _ -> true
  | _ -> false


let isInterestingGlobalName =
  let regexp =
    let pattern =
      let names = [
	"gdk_debug_level"; "gdk_show_events"; "gdk_stack_trace";
	"sys_nerr"
      ] in
      let prefixed = "^cbi_" in
      "^\\(" ^ (String.concat "\\|" names) ^ "\\)$\\|" ^ prefixed
    in
    Str.regexp pattern
  in
  (fun name -> not (Str.string_match regexp name 0))


let isInterestingLocalName =
  let regexp =
    let pattern =
      let names = ["__cil_tmp[0-9]*";
		   "tmp";
		   "__result";
		   "__s";
		   "__s1"; "__s1_len";
		   "__s2"; "__s2_len";
		   "__u";
		   "__c"] in
      let scope = "\\([_0-9A-Za-z]+\\$\\)?" in
      let alpha = "\\(___[0-9]+\\)?" in
      "^" ^ scope ^ "\\(" ^ (String.concat "\\|" names) ^ "\\)" ^ alpha ^ "$"
    in
    Str.regexp pattern
  in
  (fun name -> not (Str.string_match regexp name 0))


let hasInterestingName varinfo =
  if varinfo.vglob then
    isInterestingGlobalName varinfo.vname
  else
    isInterestingLocalName varinfo.vname


let isInterestingVar isInterestingType varinfo =
  isInterestingType varinfo.vtype &&
  hasInterestingName varinfo


let isInterestingLval isInterestingType lval =
  let isInterestingHost = function
    | Var var when hasInterestingName var ->
	Some (if var.vglob then "global" else "local")
    | Mem _ when !assignAcrossPointer -> Some "mem"
    | _ -> None
  in

  let isInterestingOffset offset =
    match snd (removeOffset offset) with
    | NoOffset -> Some "direct"
    | Field _ when !assignIntoField -> Some "field"
    | Index _ when !assignIntoIndex -> Some "index"
    | _ -> None
  in

  if isInterestingType (typeOfLval lval) then
    match isInterestingHost (fst lval) with
    | None -> None
    | Some host ->
	match isInterestingOffset (snd lval) with
	| None -> None
	| Some off -> Some (host, off)
  else
    None
