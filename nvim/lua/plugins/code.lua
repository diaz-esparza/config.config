return {
  {
    dir = vim.fn.stdpath "config" .. "/local_plugins/block-gaps.nvim",
    name = "block-gaps",
    lazy = false,
    config = function()
      require("block_gaps").setup()
    end,
  },

  {
    dir = vim.fn.stdpath "config" .. "/local_plugins/PascalCamel_snake.nvim",
    name = "PascalCamel_snake",
    lazy = false,
  },

  {
    "Vigemus/iron.nvim",
    ft = { "python", "r", "sh" },
    config = function()
      require "configs.iron"
    end,
  },
}
