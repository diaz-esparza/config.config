if vim.g.loaded_block_gaps then
  return
end
vim.g.loaded_block_gaps = 1

local bg = require "block_gaps"

vim.api.nvim_create_user_command("BlockGapsToggle", bg.toggle, { desc = "Toggle block gaps" })
vim.api.nvim_create_user_command("BlockGapsEnable", bg.enable, { desc = "Show block gaps" })
vim.api.nvim_create_user_command("BlockGapsDisable", bg.disable, { desc = "Hide block gaps" })
vim.api.nvim_create_user_command("BlockGapsRefresh", bg.refresh, { desc = "Redraw block gaps" })
vim.api.nvim_create_user_command("BlockGapsBake", bg.bake, { desc = "Turn block gaps into real lines" })
