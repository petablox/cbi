open Cil
open Pretty
open Str


let predictChecks =
  Options.registerBoolean
    ~flag:"predict-checks"
    ~desc:"emit static branch prediction hints for countdown checks"
    ~ident:"PredictChecks"
    ~default:true


let isCountdown =
  let pattern = regexp "^\\(localEventCountdown[1-9][0-9]*\\|cbi_nextEventCountdown\\)$" in
  fun candidate ->
    string_match pattern candidate.vname 0


class printer =
  object (self)
    inherit defaultCilPrinterClass as super

    method pGlobal () = function
      | GPragma (Attr ("sampler_exclude_function" as directive, [AStr argument]), location)
      | GPragma (Attr ("sampler_assume_weightless" as directive, [AStr argument]), location) ->
          self#pLineDirective location ++
	    dprintf "/* #pragma %s(\"%s\") */@!" directive argument
      | other ->
	  super#pGlobal () other

    method pStmtKind next () = function
      |	If (BinOp (Gt, Lval (Var local, NoOffset), Const (CInt64 (_, IUInt, None)), _) as predicate,
	    ({ battrs = []; bstmts = [{ skind = Goto _ }] } as original),
	    ({ battrs = []; bstmts = [{ skind = Goto _ }] } as instrumented),
	    location)
	  when !predictChecks && isCountdown local
	->
	  self#pLineDirective location
            ++ (align
                  ++ text "if"
                  ++ (align
			++ text " (__builtin_expect("
			++ self#pExp () predicate
			++ text ", 1)) "
			++ self#pBlock () original)
                  ++ chr ' '
                  ++ (align
			++ text "else "
			++ self#pBlock () instrumented)
                  ++ unalign)
      |	other ->
	  super#pStmtKind next () other
  end
