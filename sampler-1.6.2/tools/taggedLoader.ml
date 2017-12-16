open Printf
open Str


class virtual t tag =
  object (self)
    val startGoal = regexp ("^<" ^ tag ^ "\\(\\( [a-z]+=\"[^\"]*\"\\)*\\)>")
    val endGoal = "</" ^ tag ^ ">"

    method private virtual sectionHandler : Attributes.t -> SectionLoader.t

    method private readOne stream start =
      if string_match startGoal start 0 then
	let attributes = Attributes.parse (matched_group 1 start) in
	let sectionStream = SectionStream.until stream endGoal in
	let handler = self#sectionHandler attributes in
	Stream.iter handler#readLine sectionStream;
	handler#finish

    method readChannel source =
      let lineStream = LineStream.of_channel source in
      let handleLine = self#readOne lineStream in
      Stream.iter handleLine lineStream      
  end
