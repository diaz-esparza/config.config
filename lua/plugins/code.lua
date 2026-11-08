return {
  -- {
  --   "diaz-esparza/nvim-conda",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   ft = { "python" },
  -- },

  {
    dir = vim.fn.stdpath "config" .. "/lua/custom_plugins/block-gaps.nvim",
    name = "block-gaps",
    lazy = false,
    config = function()
      require("block_gaps").setup()
    end,
  },

  {
    "Vigemus/iron.nvim",
    ft = { "python", "r", "sh" },
    config = function(plugins, opts)
      require "configs.iron"
    end,
  },
}
