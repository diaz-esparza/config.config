-- docker (docker-language-server from Mason)
-- Supports Dockerfile and docker-compose files
-- NOTE: vim.filetype.add for compose files is in lua/options.lua (must run eagerly, not inside lazy-loaded plugin)

vim.lsp.config("docker_language_server", {
  cmd = { "docker-language-server", "start", "--stdio" },
  filetypes = { "dockerfile", "yaml.docker-compose" },
  root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },

  -- The server expects languageId "dockercompose" for Compose files.
  -- Neovim sends the filetype by default, so we override it here.
  get_language_id = function(_, filetype)
    if filetype == "yaml.docker-compose" then
      return "dockercompose"
    end
    return filetype
  end,

  capabilities = require("nvchad.configs.lspconfig").capabilities,
  on_init = require("nvchad.configs.lspconfig").on_init,
})
