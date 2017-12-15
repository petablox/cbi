open Cil
open FindFunction
open Printf


let globals = new StackClass.container
let infos = new QueueClass.container


let register vars info =
  globals#push vars;
  infos#push info


let patch file =
  let findDecl target = find target file in
  let findDefn target = findDefinition target file in

  let dumpSignedChar = findDecl "cbi_boundDumpSignedChar" in
  let dumpUnsignedChar = findDecl "cbi_boundDumpUnsignedChar" in
  let dumpSignedShort = findDecl "cbi_boundDumpSignedShort" in
  let dumpUnsignedShort = findDecl "cbi_boundDumpUnsignedShort" in
  let dumpSignedInt = findDecl "cbi_boundDumpSignedInt" in
  let dumpUnsignedInt = findDecl "cbi_boundDumpUnsignedInt" in
  let dumpSignedLong = findDecl "cbi_boundDumpSignedLong" in
  let dumpUnsignedLong = findDecl "cbi_boundDumpUnsignedLong" in
  let dumpSignedLongLong = findDecl "cbi_boundDumpSignedLongLong" in
  let dumpUnsignedLongLong = findDecl "cbi_boundDumpUnsignedLongLong" in
  let dumpPointer = findDecl "cbi_boundDumpPointer" in

  let calls =
    let calls = ref [] in
    globals#iter
      (fun (min, max) ->
	let dumper = match min.vtype with
	| TInt (IChar, _) ->
	    if !char_is_unsigned then
	      dumpUnsignedChar
	    else
	      dumpSignedChar
	| TInt (ISChar, _) -> dumpSignedChar
	| TInt (IUChar, _) -> dumpUnsignedChar
	| TInt (IShort, _) -> dumpSignedShort
	| TInt (IUShort, _) -> dumpUnsignedShort
	| TInt (IInt, _) -> dumpSignedInt
	| TInt (IUInt, _) -> dumpUnsignedInt
	| TInt (ILong, _) -> dumpSignedLong
	| TInt (IULong, _) -> dumpUnsignedLong
	| TInt (ILongLong, _) -> dumpSignedLongLong
	| TInt (IULongLong, _) -> dumpUnsignedLongLong
	| TPtr _ -> dumpPointer
	| TEnum _ -> dumpSignedInt
	| other ->
	    ignore (bug "don't know how to dump bounds of type %a\n" d_type other);
	    failwith "internal error"
	in
	calls := mkStmtOneInstr (Call (None, Lval (var dumper), [Lval (var min);
								 Lval (var max)],
				       locUnknown)) :: !calls);
    mkBlock !calls
  in

  let dumper = emptyFunction "cbi_boundsReportDump" in
  dumper.sbody <- calls;
  dumper.svar <- findDecl dumper.svar.vname;
  file.globals <- file.globals @ [GFun (dumper, locUnknown)];

  let boundsReporter = findDecl "cbi_boundsReporter" in
  let reporter = findDefn "cbi_reporter" in
  let call = Call (None, Lval (var boundsReporter), [], locUnknown) in
  reporter.sbody.bstmts <- mkStmtOneInstr call :: reporter.sbody.bstmts


let saveSiteInfo scheme digest channel =
  SiteInfo.print channel digest scheme infos
