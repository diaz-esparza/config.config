return {
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      if not opts.keymap then
        opts.keymap = {}
      end
      opts.keymap["<Tab>"] = { "select_next", "fallback" }
      opts.keymap["<S-Tab>"] = { "select_prev", "fallback" }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      -- This Neovim data dir is shared between multiple users (via symlinks
      -- into this home). Mason bakes the install root into generated
      -- launchers and venv shebangs, so use the resolved real path instead
      -- of the per-user ~/.local/share/nvim path. The real path is
      -- group-traversable, so the artifacts work for every user.
      install_root_dir = vim.fn.resolve(vim.fn.stdpath "data") .. "/mason",
      ensure_installed = {
        "ruff",
        "basedpyright",
        "stylua",
        "shfmt",
        "bash-language-server",
      },
    },
  },
}
