let visit impls digest =
  if !Implications.saveImplications <> "" then
    TestHarness.time "saving implications"
      (fun () ->
        let channel = open_out !Implications.saveImplications in
        output_string channel "<implications>\n";
        Implications.printAll digest channel impls;
        output_string channel "</implications>\n";
        close_out channel)
