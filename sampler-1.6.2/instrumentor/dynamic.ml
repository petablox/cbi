open Cil
open Ptranal


type resolution = Unknown | Known of varinfo list




let usePointsTo =
  Options.registerBoolean
    ~flag:"use-points-to"
    ~desc:"use a points-to analysis to resolve dynamic function calls"
    ~ident:"UsePointsTo"
    ~default:false


let analyze file =
  if !usePointsTo then
    begin
      prerr_endline "=== Points-to analysis active!";
      analyze_file file;
      compute_results false
    end


let resolve = function
  | (Var varinfo, NoOffset) ->
      Known [varinfo]
  | (Mem expression, NoOffset) ->
      if !usePointsTo then
	try
	  let result = resolve_exp expression in
	  ignore (Pretty.eprintf "=== pta: %a --> [%a]\n"
		    d_exp expression
		    (Pretty.d_list ", " (fun () varinfo -> Pretty.text varinfo.vname)) result);
	  Known result
	with UnknownLocation ->
	  ignore (Pretty.eprintf "=== pta: %a --> ???\n" d_exp expression);
	  Unknown
      else
	Unknown
  | other ->
      ignore (bug "unexpected callee: %a\n" d_lval other);
      failwith "internal error"
