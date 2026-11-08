require "nvchad.mappings"

RequireDir "mappings/utils"

local map = vim.keymap.set

map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up" })

-- Dum dum therapy
map("n", "<Left>", "")
map("n", "<Down>", "")
map("n", "<Up>", "")
map("n", "<Right>", "")

-- Error float
map("n", "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

-- Swap lines
map("n", "<M-j>", ':let save_a=@a<Cr>"add"ap:let @a=save_a<Cr>', { noremap = true, silent = true })
map("n", "<M-k>", ':let save_a=@a<Cr><Up>"add"ap<Up>:let @a=save_a<Cr>', { noremap = true, silent = true })

-- Select all
map("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- s//g
map("n", "<leader>sg", ":%s//g<Left><Left>", { noremap = true, desc = "Substitute search" })
map("v", "<leader>sg", ":s//g<Left><Left>", { noremap = true, desc = "Substitute search" })
map("n", "<leader>sr", ":%s//g<Left><Left><C-r>r/<Right>", { noremap = true, desc = 'R" substitute' })
map("v", "<leader>sr", ":s//g<Left><Left><C-r>r/<Right>", { noremap = true, desc = 'R" substitute (visual)' })

-- Buffer work
map("n", "<C-b>", function()
  local cur_buf = vim.api.nvim_get_current_buf()
  local tree_open = require("nvim-tree.view").is_visible()
  if tree_open then
    require("nvim-tree.view").close()
  end
  vim.cmd("bdelete " .. cur_buf)
  if tree_open then
    require("nvim-tree.api").tree.open()
    vim.cmd "wincmd l"
  end
end, { noremap = true, silent = true })

-- dum dum stuff
vim.cmd "cabbrev w+ w"
vim.api.nvim_create_user_command("WK", "WhichKey", {})

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("QA", "qa", {})
vim.api.nvim_create_user_command("WQA", "wqa", {})
vim.api.nvim_create_user_command("WQa", "wqa", {})
vim.api.nvim_create_user_command("Wqa", "wqa", {})

-- LSP
vim.keymap.set({ "n", "v" }, "<M-f>", vim.lsp.buf.format, { desc = "format" })

map("n", "<leader>lt", ToggleDiagnostics, { noremap = true, desc = "Toggle diagnostics" })
map("n", "<leader>ls", SetDiagnosticRange, { noremap = true, desc = "Set LSP severity range" })
vim.keymap.del("n", "<leader>ds")
map("n", "<leader>li", function()
  return vim.diagnostic.setloclist { severity = vim.g.lsp_severity }
end, { noremap = true, desc = "LSP diagnostic index" })

-- Only yank to system clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setreg("+", vim.fn.getreg '"')
    end
  end,
})
