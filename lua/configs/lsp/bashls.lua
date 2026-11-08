-- SHELL
vim.lsp.config("bashls", {
  capabilities = require("nvchad.configs.lspconfig").capabilities,
  on_init = require("nvchad.configs.lspconfig").on_init,
})
