type
  Foo* = ref object of RootObj
    id: int
  Kind = enum A, B, C
  Bar* = ref object of Foo
    ival: int
    fval: float
    sval: string
    case kind: Kind:
    of A, B: uuh: int
    of C: test: seq[int]
