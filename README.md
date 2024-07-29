Solving [OCaml Exercises](https://ocaml.org/exercises)

# Progress
| Beginner | Intermediate | Advanced |
| :------: | :----------: | :------: |
| 18       | 24           | 1        |

## :white_check_mark: Lists
- [X] 6 / 6 Beginner
- [X] 3 / 3 Intermediate
- [X] 2 / 2 Beginner Run-Length Encoding
- [X] 2 / 2 Intermediate Run-Length Encoding
- [X] 15 / 15 Remaining (Beginner and Intermediate)

## :white_check_mark: Arithmetic
- [X] 3 / 3 Beginner
- [X] 8 / 8 Intermediate

## :white_check_mark: Logic and Codes
- [X] 3 / 3 Intermediate
- [X] 1 / 1 Advanced

## Binary Trees
- [ ] 0 / 4 Beginner
- [ ] 0 / 12 Intermediate
- [ ] 0 / 1 Advanced

## Multiway Trees
- [ ] 0 / 5

## Graphs
- [ ] 0 / 11

## Miscellaneous
- [ ] 0 / 9

# Cool Stuff

## Huffman Coding
```ocaml
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
```
At first, I put the ```List.sort``` inside the match expression:
```ocaml
match l with
    | [] -> raise (Failure "huffman: empty list")
    | [ (tr, _) ] -> tr
    | (tr0, n0) :: (tr1, n1) :: rest -> (Tree (tr0, tr1), n0 + n1) :: List.sort (fun (_, n0) (_, n1) -> n0 - n1) rest |> tree_of_list
```
That does the right thing on every recursive call - but not on the original call, when the input list is still unsorted.