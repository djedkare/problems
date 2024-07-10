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