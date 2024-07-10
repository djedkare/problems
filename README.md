Solving [OCaml Exercises](https://ocaml.org/exercises)

# Progress

## Lists
- [X] 6 / 6 Beginner
- [X] 3 / 3 Intermediate

# Notes

## Semicolons and Functions
The compiler complained when I wrote this `OUnit2` case list:
```ocaml
let cases = [
  "last none" >:: fun _ -> assert_equal (L.last []) None;
  "last some" >:: fun _ -> assert_equal (L.last [2;3;4]) (Some 4)
]
```

It turns out that the semicolon binds less tightly than an anonymous function declaration. That seems useless to me when the semicolon separates list elements, but requires one less pair of braces when a function needs to perform a side effect before returning a value:

```ocaml
let f = fun x -> log_fn_call x; do_something_smart_with x
```

But in turn, when the values in a list literal with more than one element include anonymous function literals (not necessarily at the top level - the type of `cases` above is `test list`!), they need to be wrapped in brackets.

## Automatic Code Formatting
It's not enough to have `ocamlformat ocamlformat-rpc ocaml-lsp-server` in the switch. They will only do their work if there is a `.ocamlformat` file in the project directory. Easy to overlook as it is a dotfile, and thus hidden.

## Pretty Printing
... is still tedious to me.