-- Shared LSP setup. Everything server-specific lives here; add a new server by
-- configuring it and adding its name to the `vim.lsp.enable` list below.
require("nvchad.configs.lspconfig").defaults()

-- Show the most severe diagnostic first.
vim.diagnostic.config { severity_sort = true }

-- # Python
vim.lsp.config("basedpyright", {
  -- Pin the workspace root to the monorepo so sub-package pyproject.toml's
  -- don't steal it.
  root_markers = { "uv.lock", "docker-compose.yml", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        autoImportCompletions = false,
      },
      disableOrganizeImports = true,
    },
  },
})

vim.lsp.config("ruff", {
  on_attach = function(client)
    -- Ruff doesn't always advertise code actions even though it supports them.
    client.server_capabilities.codeActionProvider = true
  end,
  init_options = {
    settings = {
      logLevel = "info",
      lint = { enable = false },
    },
  },
})

-- # C/C++
vim.lsp.config("clangd", {
  on_attach = function(client)
    client.server_capabilities.signatureHelpProvider = false
  end,
})

-- # Docker
vim.lsp.config("docker_language_server", {
  cmd = { "docker-language-server", "start", "--stdio" },
  filetypes = { "dockerfile", "yaml.docker-compose" },
  root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },
  -- The server expects languageId "dockercompose" for Compose files.
  get_language_id = function(_, filetype)
    if filetype == "yaml.docker-compose" then
      return "dockercompose"
    end
    return filetype
  end,
})

-- # Lua
vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath "config"
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    })
  end,
})

-- Servers to start. Servers with no custom config just use defaults.
vim.lsp.enable {
  "basedpyright",
  "ruff",
  "bashls",
  "clangd",
  "html",
  "cssls",
  "vtsls",
  "jsonls",
  "just",
  "zls",
  "lua_ls",
  "docker_language_server",
  "markdown_oxide",
}

-- Keymaps and tweaks applied to every attached server.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- basedpyright owns hover; ruff's copy is redundant.
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
      buffer = args.buf,
      desc = "Code actions",
    })
  end,
})

-- Java uses nvim-jdtls instead of the built-in client.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local jdtls = require "jdtls"
    local root_dir = require("jdtls.setup").find_root { "gradlew", ".git", "mvnw" }
    local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    jdtls.start_or_attach {
      cmd = { vim.fn.stdpath "data" .. "/mason/bin/jdtls", "-data", workspace_dir },
      root_dir = root_dir,
      on_attach = function(client)
        -- jdtls doesn't always advertise code actions, but it supports them.
        client.server_capabilities.codeActionProvider = true
      end,
    }

    vim.opt_local.shiftwidth = 2
  end,
})
