-- MARKDOWN
vim.lsp.config("markdown_oxide", {
  capabilities = require("nvchad.configs.lspconfig").capabilities,
  on_init = require("nvchad.configs.lspconfig").on_init,
})
