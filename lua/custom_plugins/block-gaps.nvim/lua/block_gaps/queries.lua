-- Node types that count as a "block" per language. Missing languages get no gaps.
return {
  python = [[
    (function_definition) @construct
    (class_definition) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (try_statement) @construct
    (with_statement) @construct
  ]],
  java = [[
    (method_declaration) @construct
    (class_declaration) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (try_statement) @construct
    (switch_expression) @construct
  ]],
  lua = [[
    (function_declaration) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (repeat_statement) @construct
  ]],
  javascript = [[
    (function_declaration) @construct
    (class_declaration) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (try_statement) @construct
    (switch_statement) @construct
  ]],
  typescript = [[
    (function_declaration) @construct
    (class_declaration) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (try_statement) @construct
    (switch_statement) @construct
    (interface_declaration) @construct
  ]],
  c = [[
    (function_definition) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (switch_statement) @construct
    (struct_specifier) @construct
  ]],
  cpp = [[
    (function_definition) @construct
    (class_specifier) @construct
    (if_statement) @construct
    (for_statement) @construct
    (while_statement) @construct
    (try_statement) @construct
    (switch_statement) @construct
  ]],
}
