open Pretty
open Cil

let saveImplications =
  Options.registerString
    ~flag:"save-implications"
    ~desc:"save implication information in the named file"
    ~ident:""

type data = {id: int; value: exp}

type rel = | Gt of data | Lt of data | Eq of data

let compare x y =
  match x, y with
  | Const(CInt64(ix, ILongLong, _)), Const(CInt64(iy, ILongLong, _)) ->
      Int64.compare ix iy
  | Const(CInt64(ix, IULongLong, _)), Const(CInt64(iy, IULongLong, _)) ->
      (* "huge" unsigned values look negative when treated as signed *)
      let xHuge = Int64.compare ix 0L < 0 in
      let yHuge = Int64.compare iy 0L < 0 in
      begin
	match xHuge, yHuge with
	| false, false
	| true, true ->
	    Int64.compare ix iy
	| false, true -> -1
	| true, false ->  1
      end
  | _ ->
      ignore (bug "cannot compare %a with %a" d_exp x d_exp y);
      failwith "internal error"

let deriveImplications (lid, lloc, lval, ln) (rid, rloc, rval, rn) =
  if (lloc <> rloc || lval <> rval) then
    begin
    ignore (bug "cannot derive an implication when comparisons are with different variables"); 
    failwith "internal error"
    end
  else
  let res = compare ln rn in
  let l = {id = lid; value = ln} in
  let r = {id = rid; value = rn} in
  if res > 0 then
    [(Gt l, Gt r); (Lt r, Lt l); (Eq l, Gt r); (Eq r, Lt l)]
  else if res < 0 then
    [(Gt r, Gt l); (Lt l, Lt r); (Eq r, Gt l); (Eq l, Lt r)]
  else
    [(Gt r, Gt l); (Gt l, Gt r); (Lt r, Lt l); (Lt l, Lt r); (Eq r, Eq l); (Eq l, Eq r)]

let analyze pp l =

  let rec process_all l =
    
    let rec process_set l =
      match l with
      | [] -> [] 
      | hd::tl -> 
          List.fold_left (fun l x -> List.rev_append (deriveImplications hd x) l) (process_set tl) tl
    in

    match l with
    | [] -> ()
    | hd::tl ->
      let (_,lh,vh,_) = hd in 
      let (sameVar, diffVar) = 
        List.partition (fun (_,l,v,_) -> l = lh && v = vh) tl in
        List.iter (fun (l,r) -> pp l r) (process_set (hd::sameVar)); process_all diffVar 

  in
    process_all l

let printAll digest channel l =
  let compilationUnit = Digest.to_hex (Lazy.force digest) in
  let scheme = "scalar-pairs" in

  let docImpl r1 r2 =
    let docRel r =
      (text compilationUnit)++
	(chr '\t')++
	(text scheme)++
	(chr '\t')++
	(match r with
        | Lt d -> (num d.id)++(chr '\t')++(num 0)
        | Eq d -> (num d.id)++(chr '\t')++(num 1)
        | Gt d -> (num d.id)++(chr '\t')++(num 2)
	)
    in (docRel r1)++(chr '\t')++(docRel r2)
  in

  let printPair l r =
    Pretty.fprint channel max_int ((docImpl l r)++line)

  in analyze printPair l

class type constantComparisonAccumulator =
  object
    method getInfos : unit -> (int * location * lval * exp) list 
    method addInfo : (int * location * lval * exp) -> unit 
  end

class c_impl : constantComparisonAccumulator =
  object
    val infos = ref [] 

    method addInfo (info : (int * location * lval * exp)) = 
      infos := info::!infos 
    
    method getInfos () = !infos

  end

class c_null : constantComparisonAccumulator =
  object
    method addInfo (_ : (int * location * lval * exp)) = () 
    method getInfos () = ([] : (int * location * lval * exp) list) 
  end

let getAccumulator = 
    lazy (if !saveImplications <> "" then new c_impl else new c_null)
