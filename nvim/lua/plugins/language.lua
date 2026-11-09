return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lsp"
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    ft = { "python", "lua", "sql", "r", "sh", "c", "cpp", "markdown" },
    opts = function()
      return require "configs.null-ls"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "r",
        "python",
        "c",
        "cpp",
        "java",
        "kotlin",
        "csv",
        "json",
        "html",
        "css",
        "php",
        "bash",
        "javascript",
        "typescript",
        "caddy",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "noisesfromspace/touchup.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
