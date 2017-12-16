open Cil


type info = {
    location : location;
    jump : stmt;
    target : stmt;
  }


val prepatch : Weighty.tester -> fundec -> Countdown.countdown -> info list

val jumpify : info list -> stmt list
