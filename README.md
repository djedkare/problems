Solving [OCaml Exercises](https://ocaml.org/exercises)

# Progress
| Beginner | Intermediate | Advanced |
| :------: | :----------: | :------: |
| 15       | 13           | 0        |
(table not always up to date)

## :white_check_mark: Lists
- [X] 6 / 6 Beginner
- [X] 3 / 3 Intermediate
- [X] 2 / 2 Beginner Run-Length Encoding
- [X] 2 / 2 Intermediate Run-Length Encoding
- [X] 15 / 15 Remaining (Beginner and Intermediate)

## Arithmetic
- [ ] ...

## Logic and Codes
- [ ] ...

## Binary Trees
- [ ] ...

## Multiway Trees
- [ ] ...

## Graphs
- [ ] ...

## Miscellaneous
- [ ] ...

# Notes

## Using Standard Library Functions
Some of the easy exercises are reimplementations of standard library functions. The harder exercises are tedious to solve without using `List.map` etc. I think I solved too many exercises implementing every little helper function myself.

## Semicolons and Functions
The compiler complained when I wrote this `OUnit2` case list:
```ocaml
let cases = [
  "last none" >:: fun _ -> assert_equal (L.last []) None;
  "last some" >:: fun _ -> assert_equal (L.last [2;3;4]) (Some 4)
]
```

It turns out that the semicolon binds less tightly than an anonymous function declaration. That seems useless to me when the semicolon separates list elements, but when a function needs to perform a side effect before returning a value, it requires one less pair of parens:

```ocaml
let f = fun x -> log_fn_call x; do_something_smart_with x
```

But in turn, when the values in a list literal with more than one element include anonymous function literals (not necessarily at the top level - the type of `cases` above is `test list`!), they need to be wrapped in brackets.

## Automatic Code Formatting
It's not enough to have `ocamlformat ocamlformat-rpc ocaml-lsp-server` in the switch. They will only do their work if there is a `.ocamlformat` file in the project directory. Easy to overlook as `.ocamlformat` is hidden by default, being a dotfile.

## Pretty Printing
... is still tedious to me. Thus far, in the small test cases I've written, I've not yet needed the extra control over formatting that `Format`/`Fmt` give me compared to Haskell's `Show` instances. Building default, "`Show`-like" instances such as
```ocaml
let list_ a = Fmt.(brackets (list ~sep:semi a))
```
or
```ocaml
let pair_ a b = Fmt.(parens (pair ~sep:comma a b))
```
and a function that turns a `'a Fmt.t` into a `'a -> string` removes most of the hassle (but still, why does `OUnit2` work with a different type of pretty-printer than `Format`/`Fmt`? Annoying...).

## Constructors
... are uncurried, unlike in Haskell.

## Module Access
For how far to the right of the dot does module access change the scope? I would have thought, just for the next "thing" (either a single identifier or an expression wrapped in parens), but at least for type constructors that doesn't seem to be the case:
```ocaml
utop # module M = struct
type a = | A
let a_fun A = 3 end;;
module M : sig type a = A val a_fun : a -> int end
```

```ocaml
utop # M.a_fun A;;
- : int = 3
```
## Wrong Labeled Argument
The error message when a function does not accept a labeled argument of a given name:
```
The function applied to this argument has type
  some_ocaml_type
This argument cannot be applied with label ~some_label_name
```
confused me at first. Turns out the labeled argument's type was irrelevant - I just had a typo in the label name.

## Labeled vs Optional Arguments
### Labeled
- **Definition**: `~label`
  - **Or** `~label:local_variable` to expose a labeled argument named `label` but reference it as `local_variable` inside the function's body
- **Definition Body**: `label` (no tilde)
- **Type**: `label:type` (no tilde)
- **Application**: `~label:val`
  - **Shortcut**: `~label` (if the variable being passed is named `label`)

### Optional
- **Definition with Default**: `?(label=default)`
  - **Or** `?label:(local_variable=default)` to expose an optional argument named `label` but reference it as `local_variable` inside the function's body
- **Definition without Default**: `?label` exposes an option value named `label` inside the function's body
- **Definition Body**: `label` (no tilde or question mark)
- **Type**: `?label:type`
- **Application**: `~label` (tilde)
- **Application of Option**: `?label:option_value`

### Table
|              | Definition (left)        | Definition (right) | Type        | Application               |
| --           | --                       | --                 | --          | --                        |
| **Labeled**  | `~lbl`                   | `lbl`              | `lbl:type`  | `~lbl:val` (short `~lbl`) |
| **Optional** | `?(lbl=val)` <br> `?lbl` (`lbl` will be an option in the definition's body) | `lbl`              | `?lbl:type` | `~lbl:val` (short `~lbl`) <br> `?lbl:val` if `val` is and option |

## Dune Profiles
By default, `dune build`, `dune test` etc. error on any Warning. That is not useful behaviour to me: When I have written a test case for an unfinished function, I want to be able to run that test right away, without having to replace every unused argument with `_` and remove every superfluous `rec` from a `let` in the function's definition, "fixes" I'd only need to undo later. The answer seem to be `dune`'s build profiles: I can change that default behaviour with an `(env ...)` stanza, for example in a `dune` file or a `dune-workspace` file (are there others?).

For me, it was enough to have a single profile that does the default thing, except it doesn't escalate warnings into errors. For that, I had to write this into the project root's `dune` file:

```
(env
 (dev
  (flags
   (:standard -warn-error -A))))
```

While that's sufficient for this informal project and so I'll stick with it, I did try to add a second profile with different behaviour and failed. When I wrote
```
(env
 (dev
  (flags
   (:standard -warn-error -A)))
 (strict))
```
into the project's root directory's `dune` file, it didn't have an impact: `dune build` still displayed warnings. But calling `dune build --profile` with `strict`, or any profile name (except `dev`) for that matter, changes to a different behaviour: ignoring warnings.

Is the `dev` profile the only one I can use because it is predefined and all build profiles need to be declared in some place? I don't think so: changes to the `release` profile also get ignored:

```
(env
 (release
  (flags
   (:standard -w -A -warn-error -A)))
 (dev
  (flags
   (:standard -warn-error -A))))
```

My sleuthing into dune profiles is not helped by dune seemingly ignoring any profile name passed to it via `--profile` it doesn't recognize. Also, I don't know how to force dune to recompile an unchanged source file, so I have to keep changing the value of some dummy variable between calls to `dune build`. Having read ghrough every section of the dune docs relevant to profiles, I'm still clueless. Annoying.

(To be honest, my ignorance of the difference between `dune` and `dune-workspace` files, and between build profiles and build contexts, doesn't help me either.)

## Type Variables in Local Definitions
```ocaml
let id (x : 'a * 'b) : 'a * 'b = let f (y : 'b * 'a) : ('b * 'a) = y in f x;;
```
gives
```
Error: This expression has type 'a list but an expression was expected of type
         'a
       The type variable 'a occurs inside 'a list
```

So type annotations of local definitions may reference type variables of enclosing type annotations. Not ok to reuse generic names like `'a`.