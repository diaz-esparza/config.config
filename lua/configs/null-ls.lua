local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require "null-ls"

local opts = {
  sources = {
    -- sql
    null_ls.builtins.diagnostics.sqruff,
    -- lua
    null_ls.builtins.formatting.stylua,
    -- r
    null_ls.builtins.formatting.styler,
    -- sh
    null_ls.builtins.formatting.shfmt,
    -- markdown
    null_ls.builtins.formatting.mdformat,
    -- php
    null_ls.builtins.formatting.pretty_php,

    -- c, cpp, java, and more!
    -- null_ls.builtins.formatting.clang_format.with {
    --   extra_args = { "--style=Google" },
    -- },
  },

  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
    end
  end,
}

return opts
