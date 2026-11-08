require "nvchad.options"

-- Detect docker-compose files as yaml.docker-compose so LSPs attach correctly
vim.filetype.add {
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.cmd "wincmd L"
    vim.cmd "vertical resize 40"
  end,
})

local o = vim.o

o.cursorlineopt = "both" -- to enable cursorline!
o.showtabline = 2

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.number = true
o.relativenumber = true

o.lazyredraw = false
o.ttyfast = true
o.regexpengine = 2

o.clipboard = ""
