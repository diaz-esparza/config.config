-- Personal configuration for block-gaps.nvim
-- Delegates the previous acc_newline script to the polished plugin.

vim.keymap.set("n", "<leader>la", function()
  require("block_gaps").toggle()
end, { noremap = true, desc = "Toggle block-gaps accessibility" })
