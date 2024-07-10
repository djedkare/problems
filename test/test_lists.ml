open OUnit2
open Problems
module L = Problems.Lists

let cases_beginner =
  [ ("last none" >:: fun _ -> assert_equal (L.last []) None)
  ; ("last some" >:: fun _ -> assert_equal (L.last [ 2; 3; 4 ]) (Some 4))
  ; ("last_two none" >:: fun _ -> assert_equal (L.last_two [ "a" ]) None)
  ; ("last_two some"
     >:: fun _ -> assert_equal (L.last_two [ "a"; "b"; "c"; "d" ]) (Some ("c", "d")))
  ; ("nth failure" >:: fun _ -> assert_raises (Failure "nth") (fun _ -> L.nth [ "a" ] 2))
  ; ("nth value" >:: fun _ -> assert_equal (L.nth [ "a"; "b"; "c"; "d"; "e" ] 2) "c")
  ; ("length" >:: fun _ -> assert_equal (L.length [ "a"; "b"; "c"; "d"; "e" ]) 5)
  ; ("rev" >:: fun _ -> assert_equal (L.rev [ "a"; "b"; "c" ]) [ "c"; "b"; "a" ])
  ; ("is_palindrome true"
     >:: fun _ -> assert_bool "asdf" (L.is_palindrome [ "x"; "a"; "m"; "a"; "x" ]))
  ; ("is_palindrome false"
     >:: fun _ -> assert_bool "asdf" (not (L.is_palindrome [ "a"; "b" ])))
  ]
;;

let cases_intermediate =
  [ ("flatten"
     >:: fun _ ->
     assert_equal
       (L.flatten [ One "a"; Many [ One "b"; Many [ One "c"; One "d" ]; One "e" ] ])
       [ "a"; "b"; "c"; "d"; "e" ])
  ; ("compress"
     >:: fun _ ->
     assert_equal
       ~printer:(Utils.str_fn_of_pp Fmt.(list ~sep:sp string))
       [ "a"; "b"; "c"; "a"; "d"; "e" ]
       (L.compress
          [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]))
  ; ("pack"
     >:: fun _ ->
     assert_equal
       ~printer:
         (Utils.str_fn_of_pp
            Fmt.(string |> list ~sep:nop |> brackets |> list ~sep:sp |> brackets))
       [ [ "a"; "a"; "a"; "a" ]
       ; [ "b" ]
       ; [ "c"; "c" ]
       ; [ "a"; "a" ]
       ; [ "d"; "d" ]
       ; [ "e"; "e"; "e"; "e" ]
       ]
       (L.pack
          [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e" ]))
  ]
;;

let cases_run_length =
  [ ("encode"
     >:: fun _ ->
     assert_equal
       ~printer:(Utils.list_ (Utils.pair_ Fmt.int Fmt.string) |> Utils.str_fn_of_pp)
       [ 4, "a"; 1, "b"; 2, "c"; 2, "a"; 1, "d"; 4, "e" ]
       (L.E.encode
          [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]))
  ; ("encode_modified"
     >:: fun _ ->
     assert_equal
       L.E.
         [ Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e") ]
       (L.E.encode_modified
          [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]))
  ; ("decode"
     >:: fun _ ->
     assert_equal
       [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]
       (L.E.decode
          [ Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e") ])
    )
  ; ("encode_modified_direct"
     >:: fun _ ->
     assert_equal
       L.E.
         [ Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e") ]
       (L.E.encode_modified_direct
          [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]))
  ]
;;

let cases_rest =
  [ ("duplicate"
     >:: fun _ ->
     assert_equal
       [ "a"; "a"; "b"; "b"; "c"; "c"; "c"; "c"; "d"; "d" ]
       (L.duplicate [ "a"; "b"; "c"; "c"; "d" ]))
  ]
;;

let cases = cases_beginner @ cases_intermediate @ cases_run_length @ cases_rest
