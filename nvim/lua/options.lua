require "nvchad.options"

local o = vim.o

-- NvChad enables "unnamedplus"; keep the unnamed register local and copy yanks
-- to the system clipboard explicitly (see lua/mappings/autocmds.lua).
o.clipboard = ""

o.cursorlineopt = "both"
o.showtabline = 2

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.number = true
o.relativenumber = true

o.regexpengine = 2
