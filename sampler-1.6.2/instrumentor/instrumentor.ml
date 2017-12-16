open Cil
open Scanners
open TestHarness


let sample =
  Options.registerBoolean
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"
    ~default:true

let impls = Implications.getAccumulator

let schemes = [
  ScalarPairScheme.factory impls;
  BranchScheme.factory;
  BoundScheme.factory;
  FunctionEntryScheme.factory;
  ReturnScheme.factory;
  FloatKindScheme.factory;
  GObjectUnrefScheme.factory;
]


let phase =
  "instrumenting",
  fun file ->
    Dynamic.analyze file;
    FunctionFilter.filter#collectPragmas file;
    iterFuncs file IsolateInstructions.visit;
    Blast.markTerminations file;
    iterFuncs file ElaborateIfs.visit;

    let schemes = List.map (fun scheme -> scheme file) schemes in
    List.iter (fun scheme -> scheme#findAllSites) schemes;

    let digest = lazy (Digest.file file.fileName) in
    EmbedSignature.visit file digest;
    EmbedCFG.visit file digest;
    EmbedDataflow.visit file digest;
    EmbedSiteInfo.visit schemes digest;
    EmbedImplications.visit ((Lazy.force impls)#getInfos ()) digest;

    if !sample then
      begin
	let tester = Weighty.collect file in
	let countdown = new Countdown.countdown file in
	time "loading site scales" Sites.setScales;
	time "applying sampling transformation"
	  (fun () -> Transformer.visit file tester countdown)
      end;
