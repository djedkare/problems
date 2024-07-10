let str_fn_of_pp pp = Fmt.str "%a" pp
let list_ a = Fmt.(brackets (list ~sep:semi a))
let pair_ a b = Fmt.(parens (pair ~sep:comma a b))
