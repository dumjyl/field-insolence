import macros

proc find_field(ast: NimNode, field: string): NimNode =
   if ast.kind == nnkSym and ast.sym_kind == nskField and ast.eq_ident(field):
      return ast
   for i in 0 ..< ast.len:
      result = find_field(ast[i], field)
      if result != nil:
         return

macro impl(self: typed, field: static[string], ast: typed): auto =
   assert(ast.kind == nnkStmtList)
   let field_sym = find_field(ast, field)
   assert(result != nil, "failed to find field with the name: " & field)
   quote: `self`.`field_sym`

template field*[T: object](self: T, field: static[string]): auto =
   impl self, field:
      for field_val in self.fields:
         discard field_val

template field*[T: ref object](self: T, field: static[string]): auto =
   impl self, field:
      for field_val in self[].fields:
         discard field_val
