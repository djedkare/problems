module L = Problems.Logic

let eq = Test_utils.make_assert_equal_case

let cases =
  [ eq
      "table2 \"a\" \"b\" (And (Var \"a\", Or (Var \"a\", Var \"b\")))"
      [ true, true, true; true, false, true; false, true, false; false, false, false ]
      (L.table2 "a" "b" (And (Var "a", Or (Var "a", Var "b"))))
  ; eq
      "table"
      [ [ "a", true; "b", true ], true
      ; [ "a", true; "b", false ], true
      ; [ "a", false; "b", true ], false
      ; [ "a", false; "b", false ], false
      ]
      (L.table [ "a"; "b" ] (And (Var "a", Or (Var "a", Var "b"))))
  ; eq "gray 3" [ "000"; "001"; "011"; "010"; "110"; "111"; "101"; "100" ] (L.gray 3)
  ]
;;
