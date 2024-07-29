type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let flip tr =
  match tr with
  | Empty -> Empty
  | Node (a, tr0, tr1) -> Node (a, tr1, tr0)
;;

let example_tree =
  Node
    ( 'a'
    , Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty))
    , Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)) )
;;

let rec product_map f l0 l1 =
  match l0 with
  | [] -> []
  | h0 :: t0 -> List.map (f h0) l1 @ product_map f t0 l1
;;

let rec cbal_tree (n_old : int) : char binary_tree list =
  let make_tree tr0 tr1 = Node ('x', tr0, tr1) in
  if n_old < 0
  then raise (Failure "cbal_tree: negative input")
  else if n_old = 0
  then [ Empty ]
  else (
    (* if n_old = 1
       then [ Node ('x', Empty, Empty) ]
       else *)
    let n = n_old - 1 in
    if n mod 2 = 0
    then (
      let trl = cbal_tree (n / 2) in
      product_map make_tree trl trl)
    else (
      let n_halves = n / 2 in
      let n_halves_rounded_up = (n / 2) + 1 in
      let trl0 = cbal_tree n_halves in
      let trl1 = cbal_tree n_halves_rounded_up in
      product_map make_tree trl0 trl1 @ product_map make_tree trl1 trl0))
;;

let rec is_mirror tr0 tr1 =
  match tr0, tr1 with
  | Empty, Empty -> true
  | Empty, Node (_, _, _) -> false
  | Node (_, _, _), Empty -> false
  | Node (_, ltr0, ltr1), Node (_, rtr0, rtr1) ->
    is_mirror ltr0 rtr1 && is_mirror ltr1 rtr0
;;

let is_symmetric (tr : 'a binary_tree) : bool = is_mirror tr tr

let rec construct (l : int list) : int binary_tree =
  match l with
  | [] -> Empty
  | h :: t ->
    Node
      ( h
      , t |> List.filter (fun n -> n < h) |> construct
      , t |> List.filter (fun n -> n > h) |> construct )
;;

(** all symmetric, completely balanced trees of size [n] *)
let sym_cbal_trees n = cbal_tree n |> List.filter is_symmetric
