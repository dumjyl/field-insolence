import dep, ../field_insolence

var bar = Bar()
bar.field("id") = 1
bar.field("ival") = 123
bar.field("fval") = 43.52
bar.field("sval") = "abc"
echo bar.field("kind")
echo bar[]
