open OUnit2

module L = Problems.Lists

let cases = [
  "last none" >:: (fun _ -> assert_equal (L.last []) None);
  "last some" >:: (fun _ -> assert_equal (L.last [2;3;4]) (Some 4));
  "last_two none" >:: (fun _ -> assert_equal (L.last_two ["a"]) None);
  "last_two some" >:: (fun _ -> assert_equal (L.last_two ["a"; "b"; "c"; "d"]) (Some ("c", "d")));
  "nth failure" >:: (fun _ -> assert_raises (Failure "nth") (fun _ -> L.nth ["a"] 2));
  "nth value" >:: (fun _ -> assert_equal (L.nth ["a"; "b"; "c"; "d"; "e"] 2) "c");
  "length" >:: (fun _ -> assert_equal (L.length ["a"; "b"; "c"; "d"; "e"]) 5);
  "rev" >:: (fun _ -> assert_equal (L.rev ["a"; "b"; "c"]) ["c"; "b"; "a"]);
  "is_palindrome true" >:: (fun _ -> assert_bool "asdf" (L.is_palindrome ["x"; "a"; "m"; "a"; "x"]));
  "is_palindrome false" >:: (fun _ -> assert_bool "asdf" (not (L.is_palindrome ["a"; "b"])));
]