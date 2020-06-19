import macros

proc find_field_rec(ast: NimNode, field: string): NimNode =
   if ast.kind == nnkSym and ast.sym_kind == nskField and ast.eq_ident(field):
      return ast
   for i in 0 ..< ast.len:
      result = find_field_rec(ast[i], field)
      if result != nil:
         return

proc find_field(ast: NimNode, field: string): NimNode =
   assert(ast.kind == nnkStmtList)
   result = find_field_rec(ast, field)
   assert(result != nil, "failed to find field with the name: " & field)

macro get_field(self: typed, field: static[string], ast: typed): auto =
   let field = find_field(ast, field)
   quote: `self`.`field`

macro set_field(self: typed, field: static[string], val: typed, ast: typed): auto =
   let field = find_field(ast, field)
   quote: `self`.`field` = `val`

template field*[T: object](self: T, field: static[string]): auto =
   get_field self, field:
      for field_val in self.fields:
         discard field_val

template `field=`*[T: object](self: T, field: static[string], val: auto): auto =
   set_field self, field, val:
      for field_val in self.fields:
         discard field_val

template field*[T: ref object](self: T, field: static[string]): auto =
   get_field self, field:
      for field_val in self[].fields:
         discard field_val

template `field=`*[T: ref object](self: T, field: static[string], val: auto): auto =
   set_field self, field, val:
      for field_val in self[].fields:
         discard field_val
