open Cil


(* Identify possibly-initialized and definitely-uninitialized
   variables at each statement in the given function.  Analysis is
   restricted to the given list of variables of interest; this will
   typically be fundec.slocals or some selected subset thereof.

   Note: analysis results are stored internally within this module.
   Each new analysis destroys the results of all previous analyses.
   Moving to a more functional style is not hard, but incurs data
   structure copying costs that aren't worth paying unless we
   genuinely need multiple outstanding analyses.  So far, we don't. *)

val analyze : fundec -> varinfo list -> unit


(* Pose queries on the results of the most recent analysis.  At a
   given statement, is the given variable possibly initialized?
   Returns true if the variable may have been initialized; false if it
   must be uninitialized.

   Returns true if the given variable was not in the list of variables
   of interest for the most recent analysis.  May return random
   results or raise Not_found if the given statement is not from the
   most recently analyzed function, so ... don't do that. *)

val possibly : stmt -> varinfo -> bool
