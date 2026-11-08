-- PYTHON
vim.lsp.config("basedpyright", {
  capabilities = require("nvchad.configs.lspconfig").capabilities,

  on_init = require("nvchad.configs.lspconfig").on_init,

  -- Pin the workspace root to the monorepo so sub-package pyproject.toml's
  -- don't steal it. basedpyright itself still walks up for [tool.basedpyright],
  -- but Neovim's workspace folder must be the root for LSP features to work.
  root_markers = { "uv.lock", "docker-compose.yml", ".git" },

  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        -- vvvvvvv
        typeCheckingMode = "standard",
        autoImportCompletions = false,
      },
      disableOrganizeImports = true,
    },
  },
})

vim.lsp.config("ruff", {
  capabilities = require("nvchad.configs.lspconfig").capabilities,

  on_attach = function(client, bufnr)
    -- Enable code actions
    client.server_capabilities.codeActionProvider = true
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
    -- Signature help
    -- vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "R: Signature help" })
  end,

  init_options = {
    settings = {
      logLevel = "info",
      lint = {
        enable = false,
      },
    },
  },
})

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
