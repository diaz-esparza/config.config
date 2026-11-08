-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "vscode_dark",

  changed_themes = {
    vscode_dark = {},
  },

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

local vscode_dark = M.base46.changed_themes.vscode_dark
vscode_dark.base_30 = {
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

if vscode_dark then
  vscode_dark.base_16 = {
    --author of this template Tomas Iser, @tomasiser on github,
    base00 = vscode_dark.base_30.black,
    base01 = vscode_dark.base_30.black2,
    base02 = vscode_dark.base_30.one_bg,
    base03 = vscode_dark.base_30.grey,
    base04 = vscode_dark.base_30.grey_fg,
    base05 = vscode_dark.base_30.white,
    base06 = "#b6bdca",
    base07 = "#c8ccd4",
    base08 = vscode_dark.base_30.purple,
    base09 = vscode_dark.base_30.nord_blue,
    base0A = vscode_dark.base_30.green,
    base0B = vscode_dark.base_30.orange,
    base0C = vscode_dark.base_30.cyan,
    base0D = vscode_dark.base_30.yellow,
    base0E = vscode_dark.base_30.pink,
    base0F = vscode_dark.base_30.white,
  }

  vscode_dark.polish_hl = {
    treesitter = {
      ["@variable.parameter"] = { fg = vscode_dark.base_30.blue },
      ["@keyword"] = { fg = vscode_dark.base_30.teal },
      ["@variable"] = { fg = vscode_dark.base_30.cyan },
      ["@variable.member.key"] = { fg = vscode_dark.base_30.green },
      ["@constructor"] = { fg = vscode_dark.base_30.green },
      ["@keyword.return"] = { fg = vscode_dark.base_30.pink },
      ["@keyword.import"] = { fg = vscode_dark.base_30.pink },
      ["@keyword.function"] = { fg = vscode_dark.base_30.teal },
      ["@keyword.repeat"] = { fg = vscode_dark.base_30.teal },
    },
  }
end

return M
