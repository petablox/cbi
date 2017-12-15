open Cil
open Interesting
open Pretty


type direction = Min | Max


let updateBound best example direction location =
  let example = mkCast example best.vtype in
  let best = var best in
  let op = match direction with
  | Min -> Lt
  | Max -> Gt
  in
  If (BinOp (op, example, Lval best, intType),
      mkBlock [mkStmtOneInstr (Set (best, example, location))],
      mkBlock [],
      location)


let makeGlobals =
  let nextId = ref 0 in
  fun typ ->
    let typ = match typ with
    | TEnum _ -> intType
    | _ -> typ
    in
    let prefix = "samplerBounds_" ^ (string_of_int !nextId) in
    incr nextId;
    let makeGlobal suffix =
      let result = makeGlobalVar (prefix ^ suffix) typ in
      result.vstorage <- Static;
      result
    in
    (makeGlobal "_min", makeGlobal "_max")


let extremesUnsigned typ =
  mkCast zero typ,
  mkCast mone typ


let extremesSigned bits typ =
  let shift initial =
    mkCast (kinteger64 ILongLong (Int64.shift_right initial (64 - bits))) typ
  in
  shift Int64.min_int,
  shift Int64.max_int


let extremes typ =
  let builder = match typ with
  | TInt (ikind, _) ->
      begin
	match ikind with
	| IChar ->
	    if !char_is_unsigned then
	      extremesUnsigned
	    else
	      extremesSigned 8
	| ISChar -> extremesSigned 8
	| IShort -> extremesSigned 16
	| IInt | ILong -> extremesSigned 32
	| ILongLong -> extremesSigned 64
	| IUChar | IUInt | IUShort | IULong | IULongLong -> extremesUnsigned
      end
  | TPtr _ ->
      extremesUnsigned
  | TEnum _ ->
      extremesSigned 32
  | other ->
      ignore (bug "don't know extreme values of type %a\n" d_type other);
      failwith "internal error"
  in
  builder typ


let d_columns = seq ~sep:(chr '\t') ~doit:(fun doc -> doc)


class visitor global func =
  object (self)
    inherit SiteFinder.visitor

    val mutable globals = [global]
    method globals = globals

    method vstmt stmt =
      let build replacement left location (host, offset) =
	let leftType = unrollType (typeOfLval left) in
	let newLeft = var (Locals.makeTempVar func leftType) in
	let min, max = makeGlobals leftType in
	let maxInit, minInit = extremes leftType in
	globals <-
	  GVar (min, {init = Some (SingleInit minInit)}, location) ::
	  GVar (max, {init = Some (SingleInit maxInit)}, location) ::
	  globals;
	let siteInfo = new BoundSiteInfo.c func location left host offset in
	let implementation = siteInfo#implementation in
	implementation.skind <- Block (mkBlock [mkStmt (updateBound min (Lval newLeft) Min location);
						mkStmt (updateBound max (Lval newLeft) Max location)]);
	Sites.registry#add func (Site.build implementation);
	BoundManager.register (min, max) siteInfo;
	Block (mkBlock [mkStmtOneInstr (replacement newLeft);
			implementation;
			mkStmtOneInstr (Set (left, Lval newLeft, location))])
      in

      let isInterestingLval = isInterestingLval isDiscreteType in

      match IsolateInstructions.isolated stmt with
      | Some (Set (left, expr, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Set (temp, expr, location)) in
		stmt.skind <- build replacement left location info;
	  end;
	  SkipChildren

      | Some (Call (Some left, callee, args, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Call (Some temp, callee, args, location)) in
		stmt.skind <- build replacement left location info;
	  end;
	  SkipChildren

      | _ ->
	  DoChildren
  end
