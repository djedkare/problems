open OUnit2

let suite =
  "Suite"
  >::: Test_lists.cases
       @ Test_arithmetic.cases
       @ Test_logic.cases
       @ Test_binary_tree.cases
;;

let () = run_test_tt_main suite
