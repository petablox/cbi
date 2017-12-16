open Cil
open Dataflow
open Pretty


(* variables are totally ordered by their assigned unique ID numbers *)
module VariableOrder =
  struct
    type t = varinfo
    let compare var1 var2 =
      Pervasives.compare var1.vid var2.vid
  end


(* a set of variables *)
module VariableSet = Set.Make (VariableOrder)


(* format a set of variables for printing via the Pretty module *)
let d_varset () vars =
  let elements = VariableSet.elements vars in
  let d_var var = text var.vname in
  chr '{' ++ docList d_var () elements ++ chr '}'


(* dataflow transfer functions for finding uninitialized variables

   Note that while the module exports a "What might be initialized?"
   interface, the implementation actually computes "What must be
   uninitialized?"  Specifically, the dataflow value at each statement
   is the set of variables which are known to not be initialized at
   that statement.  A critical "not" on the last line of this file
   converts what we compute into what the caller wants to see. *)

module Transfer =
  struct
    let name = "Uninitialized.Transfer"
    let debug = ref false

    type t =
	(* a set of definitely uninitialized variables *)
	VariableSet.t

    let copy uninits =
      (* variable sets are not imperative, so sharing is fine *)
      uninits

    let stmtStartData =
      (* fairly arbitrary initial size *)
      Inthash.create 32

    let pretty =
      (* pretty printing helper *)
      d_varset

    let computeFirstPredecessor _ uninits =
      (* initial value is exactly what reached here, no more, no less *)
      uninits

    let combinePredecessors _ ~old add =
      (* var is uninitialized if both old and add agree that it is so *)
      let both = VariableSet.inter old add in
      if VariableSet.equal old both then
	None
      else
	Some both

    let doInstr instr uninits =
      (* remove a simple, assigned-to variable from the uninitialized set *)
      let noteAssignment vars = function
	| (Var receiver, NoOffset) ->
	    VariableSet.remove receiver vars
	| _ -> vars
      in

      (* various ways a variable can receive assignments *)
      match instr with
      | Set (lval, _, _)
      | Call (Some lval, _, _, _) ->
	  Done (noteAssignment uninits lval)
      | Call (None, _, _, _) ->
	  Default
      | Asm (_, _, outputs, _, _, _) ->
	  let folder vars (_, _, lval) =
	    noteAssignment vars lval
	  in
	  let filtered = List.fold_left folder uninits outputs in
	  Done filtered

    let doStmt _ _ =
      (* standard traversal of contained instructions, then successors *)
      SDefault

    let doGuard _ _ =
      (* standard guard predicate treatment *)
      GDefault

    let filterStmt _ =
      (* all statements are worth examining *)
      true
  end


(* dataflow analysis for finding uninitialized variables *)
module DataFlow = ForwardsDataFlow (Transfer)



(* perform a new analysis, destroying any previous results in the process *)
let analyze func vars =

  (* compute a starting set of vars that are uninitialized at function entry *)
  let uninitAtEntry =
    let folder vars var =
      (* extreme pointer conservatism: if address is *ever* taken, assume var is already initialized *)
      if var.vaddrof then
	vars
      else
	VariableSet.add var vars
    in
    List.fold_left folder VariableSet.empty vars
  in

  (* set up and perform a new dataflow analysis *)
  (* note: clobbers the previous analysis results, so only do one function at a time! *)
  let entry = List.hd func.sbody.bstmts in
  Inthash.clear Transfer.stmtStartData;
  Inthash.add Transfer.stmtStartData entry.sid uninitAtEntry;
  DataFlow.compute [entry]


(* probe the most recent analysis results at a statement of interest *)
let possibly stmt =
  (* find the set of uninitialized variables at this statement *)
  let uninits = Inthash.find Transfer.stmtStartData stmt.sid in

  (* invert "must be uninitialized" to answer "may be initialized" *)
  fun var -> not (VariableSet.mem var uninits)
