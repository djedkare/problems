open OUnit2

module L = Problems.Lists

let cases = [
  ("last none" >:: fun _ -> assert_equal (L.last []) None);
  "last some" >:: (fun _ -> assert_equal (L.last [2;3;4]) (Some 4));
  "last_two none" >:: (fun _ -> assert_equal (L.last_two ["a"]) None);
  "last_two some" >:: (fun _ -> assert_equal (L.last_two ["a"; "b"; "c"; "d"]) (Some ("c", "d")))
]