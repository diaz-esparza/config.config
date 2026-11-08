-- Quickfix opens as a right-hand vertical split.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.cmd "wincmd L"
    vim.cmd "vertical resize 40"
  end,
})

-- `clipboard` is off (see options.lua), so yanks go to the system clipboard
-- explicitly. Deletes and changes stay in the unnamed register.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setreg("+", vim.fn.getreg '"')
    end
  end,
})
