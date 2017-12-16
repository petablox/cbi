open Cil


let idents = ref ["Version", fun () -> Version.version]


let register ident =
  idents := ident :: !idents


let constAttr = [Attrs.const]


let phase =
  "adding ident strings",
  fun file ->
    let element = TInt (IChar, constAttr) in
    let typ = TPtr (element, Attr ("unused", []) :: constAttr) in
    let varinfo = makeGlobalVar "samplerIdent" typ in
    varinfo.vstorage <- Static;

    let text =
      let folder prefix (name, renderer) =
	prefix ^ "$Sampler" ^ name ^ ": " ^ renderer () ^ " $"
      in
      List.fold_left folder "" !idents
    in

    let init = SingleInit (mkString text) in
    let global = GVar (varinfo, { init = Some init }, locUnknown) in
    file.globals <- global :: file.globals
