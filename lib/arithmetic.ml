module L = Lists

(* better than the range function we built in a list exercise - see EWD 831! *)
let rec range lower upper =
  if lower = upper
  then []
  else if lower < upper
  then lower :: range (lower + 1) upper
  else (lower - 1) :: range (lower - 1) upper (* descending *)
;;

let is_prime (n : int) : bool =
  if n < 2 then false else List.for_all (fun k -> n mod k <> 0) (range 2 n)
;;

let gcd (k : int) (l : int) : int =
  let rec iter k l = if l mod k = 0 then k else iter (l mod k) k in
  if k <= l then iter k l else iter l k
;;

let coprime (k : int) (l : int) : bool = gcd k l = 1

(** if [is_prime n], then [phi n = n-1] *)
let phi (m : int) : int =
  if m = 1 then 1 else range 1 m |> List.filter (fun r -> coprime r m) |> List.length
;;

let factors (n : int) : int list =
  let rec iter n k =
    if n < 2 then [] else if n mod k = 0 then k :: iter (n / k) k else iter n (k + 1)
  in
  if n < 2 then [] else iter n 2
;;

let factors2 (n : int) : (int * int) list =
  factors n |> L.E.encode |> List.map (fun (x, y) -> y, x)
;;

let rec pow a b =
  if b < 0
  then raise (Failure "pow: negative exponent")
  else if b = 0
  then 1
  else a * pow a (b - 1)
;;

let phi_improved (m : int) : int =
  let rec iter l =
    match l with
    | [] -> 1
    | (p, m) :: t -> (p - 1) * pow p (m - 1) * iter t
  in
  iter (factors2 m)
;;

(* Compare the Two Methods of Calculating Euler's Totient Function *)
(* Use the solutions of problems "Calculate Euler's totient function φ(m)" and "Calculate *)
   (* Euler's totient function φ(m) (improved)" to compare the algorithms. Take the number *)
(* of logical inferences as a measure for efficiency. Try to calculate φ(10090) as an *)
(* example. *)

(* copied straight from the solution tbh *)
(* let timeit f a =
   let t0 = Unix.gettimeofday () in
   ignore (f a);
   let t1 = Unix.gettimeofday () in
   t1 -. t0
   ;; *)

let all_primes (lower : int) (upper : int) : int list =
  List.filter is_prime (range lower (upper + 1))
;;

let goldbach (n : int) : int * int =
  if n mod 2 <> 0
  then raise (Failure "goldbach: input not even")
  else if n <= 2
  then raise (Failure "goldbach: input too small")
  else (
    let fst_prime = List.find (fun p -> is_prime (n - p)) (all_primes 2 n) in
    fst_prime, n - fst_prime)
;;

let goldbach_list (lower : int) (upper : int) : (int * (int * int)) list =
  range lower (upper + 1)
  |> List.filter (fun n -> n mod 2 = 0 && n > 2)
  |> List.map (fun n -> n, goldbach n)
;;

let goldbach_list_large (lower : int) (upper : int) : (int * (int * int)) list =
  goldbach_list lower upper |> List.filter (fun (_, (a, b)) -> a > 50 && b > 50)
;;

(* 10 results under 3000: *)
(* utop # goldbach_list_large 0 3000;;
   - : (int * (int * int)) list =
     [(992, (73, 919)); (1382, (61, 1321)); (1856, (67, 1789)); (1928, (61, 1867));
 (2078, (61, 2017)); (2438, (61, 2377)); (2512, (53, 2459));
 (2530, (53, 2477)); (2618, (61, 2557)); (2642, (103, 2539))] *)
