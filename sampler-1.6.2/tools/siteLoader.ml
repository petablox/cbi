open Filename
open Unix


let extractor = (dirname Sys.executable_name) ^ "/extract-section --require .debug_site_info $filename"


class loader registry filename =
  object
    inherit TaggedLoader.t "sites"

    method private sectionHandler attributes =
      let unit = attributes#find "unit" in
      let scheme = attributes#find "scheme" in
      let finisher lines =
	registry#add (unit, scheme) (filename, lines)
      in
      new SectionCollector.t finisher
  end


let read registry filename =
  let loader = new loader registry filename in
  let (channel, finish) =
    if check_suffix filename ".sites" then
      (open_in filename, ignore)
    else
      begin
	putenv "filename" filename;
	let out = open_process_in extractor in
	let finish () =
	  match close_process_in out with
	  | WEXITED 0 -> ()
	  | WEXITED code
	  | WSIGNALED code
	  | WSTOPPED code ->
	      exit code
	in
	(out, finish)
      end
  in
  loader#readChannel channel;
  finish ()
