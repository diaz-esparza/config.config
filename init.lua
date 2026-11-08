USE_IMAGE_NVIM = false

-- END FLAGS

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

if USE_IMAGE_NVIM then
  require "configs.custom.checkers.luarocks"
  require "configs.custom.checkers.tmux"
  require "configs.custom.setup.imagenvim"
end

require "configs.custom.setup.severitysort"

function RequireDir(folder)
  local config_path = vim.fn.stdpath "config"
  local full_path = config_path .. "/lua/" .. folder

  for _, file in ipairs(vim.fn.readdir(full_path)) do
    if file:match "%.lua$" then
      local module = folder .. "." .. file:gsub("%.lua$", "")
      require(module)
    end
  end
end

vim.schedule(function()
  RequireDir "mappings"
end)
