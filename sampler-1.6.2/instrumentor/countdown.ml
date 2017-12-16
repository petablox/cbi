open Cil
open Weight


let specializeEmptyRegions =
  Options.registerBoolean
    ~flag:"specialize-empty-regions"
    ~desc:"specialize countdown checks for regions with no sampling sites"
    ~ident:"SpecializeEmptyRegions"
    ~default:true

let specializeSingletonRegions =
  Options.registerBoolean
    ~flag:"specialize-singleton-regions"
    ~desc:"specialize countdown checks for regions with exactly one sampling site"
    ~ident:"SpecializeSingletonRegions"
    ~default:true

let cacheCountdown =
  Options.registerBoolean
    ~flag:"cache-countdown"
    ~desc:"cache the global countdown in local variables"
    ~ident:"CacheCountdown"
    ~default:true


let findGlobal = FindGlobal.find "cbi_nextEventCountdown"


let findReset file = Lval (var (FindFunction.find "cbi_getNextEventCountdown" file))


let find file = (findGlobal file, findReset file)


class countdown file =
  let global = var (findGlobal file) in
  let reset = findReset file in
  fun fundec ->
    let local =
      if !cacheCountdown then
	var (Locals.makeTempVar fundec ~name:"localEventCountdown" uintType)
      else
	global
    in

    object (self)
      val emptyRegionCount = ref 0
      val singletonRegionCount = ref 0
      val otherRegionCount = ref 0

      method printStats =
	Printf.eprintf "stats: countdown: %s has %d empty regions, %d singleton regions, %d other regions\n"
	  fundec.svar.vname !emptyRegionCount !singletonRegionCount !otherRegionCount

      method decrement location scale =
	Instr [Set (local, increm (Lval local) (- scale), location)]

      method export location =
	Set (global, (Lval local), location)

      method import location =
	Set (local, (Lval global), location)

      method checkThreshold location weight instrumented original =
	assert (Labels.hasGotoLabel original);
	assert (Labels.hasGotoLabel instrumented);
	if !BalancePaths.balancePaths && weight.threshold > 0 then
	  original.skind <- Block (mkBlock [mkStmt (self#decrement location weight.threshold);
					    mkStmt original.skind]);
	let gotoOriginal = Goto (ref original, location) in
	let gotoInstrumented = Goto (ref instrumented, location) in
	match weight.count with
	| 0 when !specializeEmptyRegions ->
	    incr emptyRegionCount;
	    gotoOriginal
	| 1 when !specializeSingletonRegions ->
	    incr singletonRegionCount;
	    gotoInstrumented
	| _ ->
	    incr otherRegionCount;
	    let within = kinteger IUInt weight.threshold in
	    let predicate = BinOp (Gt, Lval local, within, intType) in
	    let choice = If (predicate,
			     mkBlock [mkStmt gotoOriginal],
			     mkBlock [mkStmt gotoInstrumented],
			     location) in
	    choice

      method decrementAndCheckZero skind scale =
	let location = get_stmtLoc skind in
	let callReset = mkStmtOneInstr (Call (Some local, reset, [], location)) in
	Block (mkBlock [ mkStmt (self#decrement location scale);
			 mkStmt (If (BinOp (Le, Lval local, zero, intType),
				     mkBlock [ mkStmt skind; callReset ],
				     mkBlock [],
				     location)) ])
    end
