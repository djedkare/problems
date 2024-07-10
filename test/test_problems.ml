open OUnit2

let suite = "Suite" >::: Test_lists.cases
let () = run_test_tt_main suite
