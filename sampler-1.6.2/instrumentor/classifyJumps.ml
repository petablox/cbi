open Cil


type info = { forward : stmt list; backward : stmt list }


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    val seen = new StmtIdHash.c 0
	
    val mutable forwards = []
    val mutable backwards = []
    method result = { forward = forwards; backward = backwards }

    method vstmt stmt =
      begin
	match stmt.skind with
	| Goto (destination, _) ->
	    if seen#mem !destination then
	      backwards <- stmt :: backwards
	    else
	      forwards <- stmt :: forwards
	| Break _
	| Continue _
	| Loop _ ->
	    ignore (bug "loop constructs should have been converted into gotos");
	    failwith "internal error"
	| _ -> ()
      end;
      seen#add stmt ();
      DoChildren

    method vfunc func =
      NumberStatements.visit func;
      DoChildren
  end


let visit func =
  let visitor = new visitor in
  ignore (visitCilFunction (visitor :> cilVisitor) func);
  visitor#result
