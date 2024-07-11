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
