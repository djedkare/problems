module B = Problems.Binary_tree

let eq = Test_utils.make_assert_equal_case

let cases =
  [ eq "cbal_tree 4" 4 (4 |> B.cbal_tree |> List.length)
  ; eq
      "construct"
      (B.Node
         ( 3
         , Node (2, Node (1, Empty, Empty), Empty)
         , Node (5, Empty, Node (7, Empty, Empty)) ))
      (B.construct [ 3; 2; 5; 7; 1 ])
  ; eq
      "is_symmetric construct"
      true
      (B.is_symmetric (B.construct [ 5; 3; 18; 1; 4; 12; 21 ]))
  ; eq "not is_symmetric construct" false (B.is_symmetric (B.construct [ 3; 2; 5; 7; 4 ]))
  ; eq "sym_cbal_trees" 256 (List.length (B.sym_cbal_trees 57))
  ; eq "hbal_tree" 15 (List.length (B.hbal_tree 3))
  ; eq
      "at_level"
      [ 'b'; 'c' ]
      B.(
        at_level
          (Node
             ( 'a'
             , Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty))
             , Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)) ))
          2)
  ]
;;
