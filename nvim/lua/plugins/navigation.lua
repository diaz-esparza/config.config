return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      vim.g.baleia = require("baleia").setup {}

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      renderer = {
        group_empty = true,
        full_name = true,
      },
    },
  },
}
