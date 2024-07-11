let make_assert_equal_case str ?pr exn1 exn2 =
  OUnit2.(
    match pr with
    | Some pr_ ->
      str
      >:: fun _ ->
      assert_equal ~printer:(fun x -> Problems.Utils.str_fn_of_pp pr_ x) exn1 exn2
    | None -> str >:: fun _ -> assert_equal exn1 exn2)
;;
