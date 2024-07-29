module B = Problems.Binary_tree

let eq = Test_utils.make_assert_equal_case
let cases = [ eq "cbal_tree 4" 4 (4 |> B.cbal_tree |> List.length) ]
