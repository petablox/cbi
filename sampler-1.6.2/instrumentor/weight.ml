type t = {
    threshold : int;
    count : int;
  }


let weightless = {
  threshold = 0;
  count = 0;
}


let max a b = {
  threshold = Pervasives.max a.threshold b.threshold;
  count = Pervasives.max a.count b.count;
}


let sum a b = {
  threshold = a.threshold + b.threshold;
  count = a.count + b.count;
}
