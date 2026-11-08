require "nvchad.mappings"
require "mappings.autocmds"
require "mappings.commands"

local map = vim.keymap.set

-- # Navigation
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Window left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Window right" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Window down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Window up" })

for _, key in ipairs { "<Left>", "<Down>", "<Up>", "<Right>" } do
  map("n", key, "")
end

-- # Editing
-- Swap the current line with the one below/above, preserving register a.
map("n", "<M-j>", ':let save_a=@a<Cr>"add"ap:let @a=save_a<Cr>', { silent = true })
map("n", "<M-k>", ':let save_a=@a<Cr><Up>"add"ap<Up>:let @a=save_a<Cr>', { silent = true })

map("n", "<C-a>", "ggVG", { desc = "Select all" })

map("n", "<leader>sg", ":%s//g<Left><Left>", { desc = "Substitute search" })
map("v", "<leader>sg", ":s//g<Left><Left>", { desc = "Substitute search" })
map("n", "<leader>sr", ":%s//g<Left><Left><C-r>r/<Right>", { desc = 'R" substitute' })
map("v", "<leader>sr", ":s//g<Left><Left><C-r>r/<Right>", { desc = 'R" substitute' })

-- # Buffers
map("n", "<C-b>", function()
  local buf = vim.api.nvim_get_current_buf()
  local tree = require "nvim-tree.view"
  local tree_open = tree.is_visible()
  if tree_open then
    tree.close()
  end
  vim.cmd("bdelete " .. buf)
  if tree_open then
    require("nvim-tree.api").tree.open()
    vim.cmd "wincmd l"
  end
end, { silent = true, desc = "Delete buffer" })

-- # Formatting
map({ "n", "v" }, "<M-f>", vim.lsp.buf.format, { desc = "Format" })

-- # Diagnostics
local severities = { "Error", "Warn", "Info", "Hint" }

local function pick_severity(prompt, on_choice)
  vim.ui.select(severities, { prompt = prompt }, function(choice)
    if choice then
      on_choice(choice, vim.diagnostic.severity[choice:upper()])
    end
  end)
end

map("n", "<leader>i", vim.diagnostic.open_float, { desc = "Line diagnostics" })

map("n", "<leader>lt", function()
  local enabled = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(enabled)
  vim.notify("Diagnostics " .. (enabled and "enabled" or "disabled"))
end, { desc = "Toggle diagnostics" })

map("n", "<leader>ls", function()
  pick_severity("Min severity", function(min_name, min)
    pick_severity("Max severity", function(max_name, max)
      vim.g.lsp_severity = { min = min, max = max }
      vim.diagnostic.config {
        virtual_text = { severity = vim.g.lsp_severity },
        signs = { severity = vim.g.lsp_severity },
        underline = { severity = vim.g.lsp_severity },
      }
      vim.notify(("Showing %s..%s"):format(min_name, max_name), vim.log.levels.INFO, { title = "Diagnostics" })
    end)
  end)
end, { desc = "Diagnostic severity range" })

map("n", "<leader>li", function()
  vim.diagnostic.setloclist { severity = vim.g.lsp_severity }
end, { desc = "Diagnostic loclist" })

pcall(vim.keymap.del, "n", "<leader>ds")

-- # Language helpers
map("n", "<leader>la", function()
  require("block_gaps").toggle()
end, { desc = "Toggle block gaps" })

map("n", "<leader>rc", function()
  require("PascalCamel_snake").convert()
end, { desc = "Convert variable case" })
