open Cil
open Pretty
open SchemeName


class c func inspiration =
  object
    val implementation = mkEmptyStmt ()

    method fundec = func
    method inspiration : location = inspiration
    method implementation = implementation

    method print =
      let location = get_stmtLoc implementation.skind in
      let filename = Paths.normalize location in
      [filename;
       num location.line;
       text func.svar.vname;
       num implementation.sid]
  end


let print channel digest scheme infos =
  Printf.fprintf channel "<sites unit=\"%s\" scheme=\"%s\">\n"
    (Digest.to_hex (Lazy.force digest)) scheme.flag;

  infos#iter
    (fun siteInfo ->
      Pretty.fprint channel max_int
	((seq (chr '\t') (fun doc -> doc) siteInfo#print)
	   ++ line));

  output_string channel "</sites>\n"
