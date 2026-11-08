-- C/C++
vim.lsp.config("clangd", {
  capabilities = require("nvchad.configs.lspconfig").capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    require("nvchad.configs.lspconfig").on_attach(client, bufnr)
  end,
})
