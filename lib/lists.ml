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