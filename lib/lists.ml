(* Beginner *)

let rec last l =
  match l with
  | [] -> None
  | x :: [] -> Some x
  | _ :: tl -> last tl

let rec last_two l =
  match l with
  | [] -> None
  | _ :: [] -> None
  | x :: y :: [] -> Some (x, y)
  | _ :: tl -> last_two tl

let rec nth l n = match l with
  | [] -> raise (Failure "nth")
  | h :: t -> if n < 0 then raise (Failure "nth") else if n = 0 then h else nth t (n-1)

let rec length l =
  match l with
  | [] -> 0
  | _ :: t -> 1 + length t

let rec rev l =
  match l with
  | [] -> []
  | h :: t -> rev t @ [h]

let is_palindrome l =
  l = rev l

(* Intermediate *)

type 'a node =
  | One of 'a 
  | Many of 'a node list

let rec flatten l =
  match l with
  | [] -> []
  | One a :: t -> a :: flatten t
  | Many l :: t -> flatten l @ flatten t

let compress l =
  let rec iter l x =
    match l with
    | [] -> []
    | h :: t -> if h = x then iter t x else h :: iter t h
  in
  match l with
  | [] -> []
  | h :: t -> h :: iter t h

let pack l =
  let rec iter l acc =
    match l with
    | [] -> []
    | h :: t ->
      match acc with
      | [] -> iter t [h]
      | x :: _ -> if h = x then iter t (h :: acc) else acc :: iter t []
    in iter l []