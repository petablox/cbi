let main reader =
  let argc = Array.length Sys.argv in
  if argc < 1 then
    begin
      Printf.eprintf "Usage: %s [<site-info-file> ...]\n" Sys.argv.(0);
      exit 2
    end;

  let registry = new SiteRegistry.c 1 in
  for arg = 1 to (Array.length Sys.argv - 1) do
    SiteLoader.read registry Sys.argv.(arg)
  done;

  reader registry stdin
