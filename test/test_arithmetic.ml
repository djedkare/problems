(* open OUnit2 *)
open Problems
module A = Arithmetic

let eq = Test_utils.make_assert_equal_case

let cases =
  [ eq "is_prime 1" false (A.is_prime 1)
  ; eq "is_prime 2" true (A.is_prime 2)
  ; eq "is_prime 7" true (A.is_prime 7)
  ; eq "is_prime 35" false (A.is_prime 35)
  ; eq "gcd 13 27" 1 (A.gcd 13 27)
  ; eq "gcd 20536 7826" 2 (A.gcd 20536 7826)
  ; eq "coprime 13 27" true (A.coprime 13 27)
  ; eq "coprime 20536 7826" false (A.coprime 20536 7826)
  ; eq "phi 10" 4 (A.phi 10)
  ; eq "factors 315" [ 3; 3; 5; 7 ] (A.factors 315)
  ; eq "factors2 315" [ 3, 2; 5, 1; 7, 1 ] (A.factors2 315)
  ]
;;
