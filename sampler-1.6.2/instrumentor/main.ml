open Cil


let _ =

  try
    let phases =
      [
       "removing unused symbols (early)", (fun file -> Rmtmps.removeUnusedTemps file);
       Locals.rename;
       Instrumentor.phase;
       "removing unused symbols (late)", (fun file -> Rmtmps.removeUnusedTemps file);
       Idents.phase;
       "printing transformed code", (dumpFile (new Printer.printer) stdout "")
     ]
    in

    initCIL ();
    lineDirectiveStyle := Some LinePreprocessorOutput;

    Arg.parse (Options.argspecs ())
      (TestHarness.doOne phases)
      ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

  with Errormsg.Error ->
    exit 2
