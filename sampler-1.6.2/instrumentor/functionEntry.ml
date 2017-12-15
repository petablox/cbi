open Cil


let find func =
  match func.sbody.bstmts with
  | {sid = 0} as root :: _ -> root
  | _ -> ignore (bug "cannot find function entry"); dummyStmt


let patch func weights countdown instrumented =
  let entry = find func in
  let location = func.svar.vdecl in
  let import = mkStmtOneInstr (countdown#import location) in

  let original = mkStmt (Block func.sbody) in
  let instrumented = mkStmt (Block instrumented) in
  original.labels <- Label ("original", location, false) :: original.labels;
  instrumented.labels <- Label ("instrumented", location, false) :: instrumented.labels;

  let weight = weights#find entry in
  let choice = countdown#checkThreshold location weight instrumented original in

  let finis = mkEmptyStmt () in
  finis.labels <- [ Label ("finis", location, false) ];

  func.sbody <- mkBlock [ import;
			  mkStmt choice;
			  original;
			  mkStmt (Goto (ref finis, location));
			  instrumented;
			  finis ]
