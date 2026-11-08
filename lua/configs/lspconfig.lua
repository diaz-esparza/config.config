-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

require "configs.lsp.basedpyruff"
require "configs.lsp.clangd"
require "configs.lsp.jdtls"
require "configs.lsp.lua_ls"
require "configs.lsp.vtsls"
require "configs.lsp.just"
require "configs.lsp.docker_language_server"
require "configs.lsp.markdown_oxide"
require "configs.lsp.bashls"

vim.lsp.enable {
  "basedpyright",
  "ruff",
  "clangd",

  "html",
  "cssls",
  "vtsls",
  "svelte",
  "jsonls",
  "just",
  "zls",

  "lua_ls",
  "docker_language_server",
  "markdown_oxide",
  "bashls",
}

-- settings

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})
