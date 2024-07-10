# Progress

## Lists
- 2 / 6

# Notes

## Semicolons and Functions

The compiler complained when I wrote this `OUnit2` case list:
```ocaml
let cases = [
  "last none" >:: fun _ -> assert_equal (L.last []) None;
  "last some" >:: fun _ -> assert_equal (L.last [2;3;4]) (Some 4)
]
```

It turns out that the semicolon binds less tightly than an anonymous function declaration. That seems useless to me when the semicolon separates list elements, but has its use when a function needs to perform a side effect before returning a value:

```ocaml
fun x -> log_fn_call x; do_something_smart_with x
```

But in turn, when the values in a list literal with more than one element include anonymous function literals (not necessarily at the top level - the type of `cases` above is `test list`!), they need to be wrapped in brackets.