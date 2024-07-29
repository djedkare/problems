type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr

let rec eval2 (var0, val0) (var1, val1) expr =
  match expr with
  | Var str ->
    if str = var0
    then val0
    else if str = var1
    then val1
    else raise (Failure "table2: lookup error")
  | Not expr_ -> not (eval2 (var0, val0) (var1, val1) expr_)
  | And (expr0, expr1) ->
    eval2 (var0, val0) (var1, val1) expr0 && eval2 (var0, val0) (var1, val1) expr1
  | Or (expr0, expr1) ->
    eval2 (var0, val0) (var1, val1) expr0 || eval2 (var0, val0) (var1, val1) expr1
;;

let table2 var0 var1 expr =
  [ true, true, eval2 (var0, true) (var1, true) expr
  ; true, false, eval2 (var0, true) (var1, false) expr
  ; false, true, eval2 (var0, false) (var1, true) expr
  ; false, false, eval2 (var0, false) (var1, false) expr
  ]
;;

let rec eval (assigns : (string * bool) list) (expr : bool_expr) : bool =
  match expr with
  | Var str -> List.assoc str assigns
  | Not expr_ -> not (eval assigns expr_)
  | And (expr0, expr1) -> eval assigns expr0 && eval assigns expr1
  | Or (expr0, expr1) -> eval assigns expr0 || eval assigns expr1
;;

let rec make_assigns l =
  match l with
  | [] -> [ [] ]
  | h :: t ->
    let assigns = make_assigns t in
    List.map (fun a -> (h, true) :: a) assigns
    @ List.map (fun a -> (h, false) :: a) assigns
;;

let table vars expr = make_assigns vars |> List.map (fun assgn -> assgn, eval assgn expr)

let rec gray n =
  if n < 0
  then raise (Failure "gray: input negative")
  else if n = 0
  then [ "" ]
  else (
    let x = gray (n - 1) in
    let prepend str0 str1 = str0 ^ str1 in
    List.map (prepend "0") x @ List.map (prepend "1") (List.rev x))
;;

let huffman (freqs : (string * int) list) : (string * string) list =
  let open struct
    type tree =
      | Tree of (tree * tree)
      | Leaf of string
  end in
  let rec tree_of_list (l : (tree * int) list) : tree =
    match List.sort (fun (_, n0) (_, n1) -> n0 - n1) l with
    | [] -> raise (Failure "huffman: empty list")
    | [ (tr, _) ] -> tr
    | (tr0, n0) :: (tr1, n1) :: rest -> (Tree (tr0, tr1), n0 + n1) :: rest |> tree_of_list
  in
  let rec decode_tree (tr : tree) : (string * string) list =
    match tr with
    | Leaf s -> [ s, "" ]
    | Tree (tr0, tr1) ->
      List.map (fun (s, code) -> s, "0" ^ code) (decode_tree tr0)
      @ List.map (fun (s, code) -> s, "1" ^ code) (decode_tree tr1)
  in
  freqs |> List.map (fun (s, n) -> Leaf s, n) |> tree_of_list |> decode_tree
;;
