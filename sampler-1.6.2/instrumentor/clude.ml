open Pretty


type disposition = Include | Exclude


let d_pattern (disposition, template) =
  let operator =
    match disposition with
    | Include -> "include"
    | Exclude -> "exclude"
  in
  text operator ++ text " " ++ text template


let string_of_patterns patterns =
  Pretty.sprint 0 (seq (text ", ") d_pattern patterns)


class filter ~flag ~desc ~ident =
  object (self)
    val mutable patterns = []

    method private append disposition template =
      patterns <- patterns @ [disposition, template]

    method addExclude = self#append Exclude
    method addInclude = self#append Include

    method included focus =
      let rec dispose = function
	| [] -> Include
	| (disposition, "*") :: _ -> disposition
	| (disposition, template) :: _ when template = focus -> disposition
	| _ :: remainder -> dispose remainder
      in
      match dispose patterns with
      | Include -> true
      | Exclude -> false

    initializer
      Options.push ("--exclude-" ^ flag, Arg.String self#addExclude, "");
      Options.push ("--include-" ^ flag, Arg.String self#addInclude, desc);
      Idents.register (ident, fun () -> string_of_patterns patterns)
  end
