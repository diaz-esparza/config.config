-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@class VscodeDark : ThemeTable
---@field polish_hl? table<string, table<string, Base46HLGroups>>

local base_30 = {
  white = "#dee1e6",
  darker_black = "#1a1a1a",
  black = "#100F0F",
  black2 = "#2a2a4f",
  one_bg = "#292626",
  one_bg2 = "#353232",
  one_bg3 = "#373434",
  grey = "#444444",
  grey_fg = "#4e4e4e",
  grey_fg2 = "#585858",
  light_grey = "#626262",
  red = "#D16969",
  baby_pink = "#ea696f",
  pink = "#bb7cb6",
  line = "#2e2e2e",
  green = "#B5CEA8",
  green1 = "#7DB893",
  vibrant_green = "#bfd8b2",
  blue = "#76a6ff",
  nord_blue = "#569CD6",
  yellow = "#D7DABD",
  sun = "#e1c487",
  purple = "#c68aee",
  dark_purple = "#b77bdf",
  teal = "#4294D6",
  orange = "#d3967d",
  cyan = "#9FDFFE",
  statusline_bg = "#242424",
  lightbg = "#303030",
  pmenu_bg = "#60a6e0",
  folder_bg = "#7A8A92",
}

---@type VscodeDark
local vscode_dark = {
  base_30 = base_30,

  base_16 = {
    --author of this template Tomas Iser, @tomasiser on github,
    base00 = base_30.black,
    base01 = base_30.black2,
    base02 = base_30.one_bg,
    base03 = base_30.grey,
    base04 = base_30.grey_fg,
    base05 = base_30.white,
    base06 = "#b6bdca",
    base07 = "#c8ccd4",
    base08 = base_30.purple,
    base09 = base_30.nord_blue,
    base0A = base_30.green,
    base0B = base_30.orange,
    base0C = base_30.cyan,
    base0D = base_30.yellow,
    base0E = base_30.pink,
    base0F = base_30.white,
  },

  polish_hl = {
    treesitter = {
      ["@variable.parameter"] = { fg = base_30.blue },
      ["@keyword"] = { fg = base_30.teal },
      ["@variable"] = { fg = base_30.cyan },
      ["@variable.member.key"] = { fg = base_30.green },
      ["@constructor"] = { fg = base_30.green },
      ["@keyword.return"] = { fg = base_30.pink },
      ["@keyword.import"] = { fg = base_30.pink },
      ["@keyword.function"] = { fg = base_30.teal },
      ["@keyword.repeat"] = { fg = base_30.teal },
    },
  },
}

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "vscode_dark",

  ---@diagnostic disable-next-line: missing-fields
  changed_themes = {
    vscode_dark = vscode_dark,
  },
}

return M
