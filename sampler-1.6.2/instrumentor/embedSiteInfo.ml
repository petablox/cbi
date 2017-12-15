open Cil


let saveSiteInfo =
  Options.registerString
    ~flag:"save-site-info"
    ~desc:"save instrumentation site info in the named file"
    ~ident:""


let visit schemes digest =
  if !saveSiteInfo <> "" then
    TestHarness.time "saving site info"
      (fun () ->
	let channel = open_out !saveSiteInfo in
	List.iter
	  (fun scheme -> scheme#saveSiteInfo digest channel)
	  schemes;
	close_out channel)
