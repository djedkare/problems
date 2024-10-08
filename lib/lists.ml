(* 10.07.2024 *)

(* Beginner *)

let rec last l =
  match l with
  | [] -> None
  | x :: [] -> Some x
  | _ :: tl -> last tl
;;

let rec last_two l =
  match l with
  | [] -> None
  | _ :: [] -> None
  | [ x; y ] -> Some (x, y)
  | _ :: tl -> last_two tl
;;

let rec nth l n =
  match l with
  | [] -> raise (Failure "nth")
  | h :: t -> if n < 0 then raise (Failure "nth") else if n = 0 then h else nth t (n - 1)
;;

let rec length l =
  match l with
  | [] -> 0
  | _ :: t -> 1 + length t
;;

let rec rev l =
  match l with
  | [] -> []
  | h :: t -> rev t @ [ h ]
;;

let is_palindrome l = l = rev l

(* Intermediate *)

type 'a node =
  | One of 'a
  | Many of 'a node list

let rec flatten l =
  match l with
  | [] -> []
  | One a :: t -> a :: flatten t
  | Many l :: t -> flatten l @ flatten t
;;

let compress l =
  let rec iter l x =
    match l with
    | [] -> []
    | h :: t -> if h = x then iter t x else h :: iter t h
  in
  match l with
  | [] -> []
  | h :: t -> h :: iter t h
;;

let pack l =
  let rec iter l acc =
    match l with
    | [] -> if acc <> [] then [ acc ] else []
    | h :: t ->
      (match acc with
       | [] -> iter t [ h ]
       | x :: _ -> if h = x then iter t (h :: acc) else acc :: iter t [ h ])
  in
  iter l []
;;

module E = struct
  (* the 4 run length encoding exercises*)
  let encode l =
    let rec iter l (n, x) =
      match l with
      | [] -> [ n, x ]
      | h :: t -> if h = x then iter t (n + 1, x) else (n, x) :: iter t (1, h)
    in
    match l with
    | [] -> []
    | h :: t -> iter t (1, h)
  ;;

  type 'a rle =
    | One of 'a
    | Many of int * 'a

  let encode_modified l =
    let rec iter l =
      match l with
      | [] -> []
      | (n, x) :: t -> (if n = 1 then One x else Many (n, x)) :: iter t
    in
    iter (encode l)
  ;;

  let rec decode l =
    match l with
    | [] -> []
    | One a :: t -> a :: decode t
    | Many (n, a) :: t -> if n > 0 then a :: decode (Many (n - 1, a) :: t) else decode t
  ;;

  let encode_modified_direct l =
    let rec iter l rle =
      match l with
      | [] -> [ rle ]
      | h :: t ->
        (match rle with
         | One a -> if h = a then iter t (Many (2, a)) else One a :: iter t (One h)
         | Many (n, a) ->
           if h = a then iter t (Many (n + 1, a)) else Many (n, a) :: iter t (One h))
    in
    match l with
    | [] -> []
    | h :: t -> iter t (One h)
  ;;
end

let rec duplicate l =
  match l with
  | [] -> []
  | h :: t -> h :: h :: duplicate t
;;

(* 11.07.2024 *)

let rec replicate l n =
  let rec prepend x n l = if n <= 0 then l else x :: prepend x (n - 1) l in
  match l with
  | [] -> []
  | h :: t -> prepend h n (replicate t n)
;;

let drop l n =
  if n < 1
  then raise (Failure "drop")
  else (
    let rec iter l i =
      match l with
      | [] -> []
      | h :: t -> if i <= 1 then iter t n else h :: iter t (i - 1)
    in
    iter l n)
;;

let rec split l n =
  let cons_fst x (a, b) = x :: a, b in
  match l with
  | [] -> [], []
  | h :: t -> if n = 0 then [], h :: t else cons_fst h (split t (n - 1))
;;

(** behaviour if [n2 > List.length l] is not specified in the problem statement,
    in this implementation [slice l n1 n2] would return the slice from [n1] to
    the end of the list *)
let rec slice l n1 n2 =
  if n1 <= 0
  then fst (split l (n2 + 1))
  else (
    match l with
    | [] -> []
    | _ :: t -> slice t (n1 - 1) (n2 - 1))
;;

(** [rotate l 0 = l]*)
let rotate l n =
  let n_ = n mod length l in
  match split l n_ with
  | a, b -> b @ a
;;

let rec remove_at n l =
  match l with
  | [] -> []
  | h :: t -> if n <= 0 then t else h :: remove_at (n - 1) t
;;

(** [insert_at s 0 l = s :: l]*)
let rec insert_at s i l =
  match l with
  | [] -> [ s ]
  | h :: t -> if i <= 0 then s :: l else h :: insert_at s (i - 1) t
;;

(** [range n n = [ n ]]*)
let rec range n1 n2 =
  if n1 = n2
  then [ n1 ]
  else if n1 < n2
  then n1 :: range (n1 + 1) n2
  else n1 :: range (n1 - 1) n2
;;

(** test with [Random.init 0] (no test case yet!) *)
let rand_select l n =
  let rec select l ns =
    match ns with
    | [] -> []
    | nh :: nt -> nth l nh :: select l nt
  in
  let rec get_rand_vals len n =
    if n <= 0 then [] else Random.int len :: get_rand_vals (len - 1) (n - 1)
  in
  let rec inc lower l =
    match l with
    | [] -> []
    | h :: t -> (if h >= lower then h + 1 else h) :: inc lower t
  in
  let rec correct_rand_vals l =
    match l with
    | [] -> []
    | h :: t -> h :: correct_rand_vals (inc h t)
  in
  get_rand_vals (length l) n |> correct_rand_vals |> select l
;;

(** [n <= m] *)
let lotto_select n m = rand_select (range 1 m) n

let permutation l = rand_select l (length l)

let rec cons_to_all l x =
  match l with
  | [] -> []
  | h :: t -> (x :: h) :: cons_to_all t x
;;

let rec extract n l =
  let rec concat l1 l2 =
    match l1 with
    | [] -> l2
    | h :: t -> h :: concat t l2
  in
  if n <= 0
  then [ [] ]
  else (
    match l with
    | [] -> []
    | h :: t -> concat (cons_to_all (extract (n - 1) t) h) (extract n t))
;;

let rec flatten_list l =
  match l with
  | [] -> []
  | h :: t -> h @ flatten_list t
;;

let rec map f l =
  match l with
  | [] -> []
  | h :: t -> f h :: map f t
;;

let concat_map f l = flatten_list (map f l)

(** returns a list of pairs of both the selection and the elements not selected *)
let rec extract2 (n : int) (l : 'a list) : ('a list * 'a list) list =
  let rec map_cons_snd (x : 't2) (l : ('t1 * 't2 list) list) : ('t1 * 't2 list) list =
    let cons_snd (a, b) = a, x :: b in
    match l with
    | [] -> []
    | h :: t -> cons_snd h :: map_cons_snd x t
  in
  let rec map_cons_fst x l (* (x : 'a) (l : ('a list * 'b) list) : ('a list * 'b) list *) =
    let cons_fst (a, b) = x :: a, b in
    match l with
    | [] -> []
    | h :: t -> cons_fst h :: map_cons_fst x t
  in
  if n <= 0
  then [ [], l ]
  else (
    match l with
    | [] -> []
    | h :: t -> map_cons_fst h (extract2 (n - 1) t) @ map_cons_snd h (extract2 n t))
;;

(** returns the results in a different order than the official solution *)
let rec group (elems : 'elem list) (groups : int list) : 'elem list list list =
  match groups with
  | [] -> [ [] ]
  | gh :: gt ->
    let extractions : ('elem list * 'elem list) list = extract2 gh elems in
    let f ((choice : 'elem list), (rest : 'elem list)) : 'elem list list list =
      map (fun solution -> choice :: solution) (group rest gt)
    in
    concat_map f extractions
;;

let rec sort (f : 'a -> int) (l : 'a list) : 'a list =
  let rec insert (x : 'a) (l : 'a list) : 'a list =
    match l with
    | [] -> [ x ]
    | h :: t -> if f x <= f h then x :: l else h :: insert x t
  in
  match l with
  | [] -> []
  | h :: t -> insert h (sort f t)
;;

let length_sort ll = sort length ll

let rec count p l =
  match l with
  | [] -> 0
  | h :: t -> (if p h then 1 else 0) + count p t
;;

(** returns the results in a different order than the official solution *)
let frequency_sort ll =
  let f l = count (fun x -> length x = length l) ll in
  sort f ll
;;
