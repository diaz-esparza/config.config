local iron = require "iron.core"
local view = require "iron.view"
local common = require "iron.fts.common"

local nvim_cmd = view.bottom(20)
local default_send = iron.send

-- Optional tmux backend: send Python code to a pane selected once per session.
local tmux = {}

function tmux.set_target()
  local panes = vim.fn.systemlist "tmux list-panes -a -F '#S:#I.#P #{pane_id}'"
  if #panes == 0 then
    vim.notify("No tmux panes found", vim.log.levels.ERROR)
    return nil
  end

  local choices = {}
  for i, entry in ipairs(panes) do
    choices[i] = ("[%d] %s"):format(i, entry)
  end

  local idx = vim.fn.inputlist(choices)
  if idx < 1 or idx > #panes then
    vim.notify("Invalid index", vim.log.levels.ERROR)
    return nil
  end

  tmux.target = panes[idx]:match "(%%%d+)$"
  return tmux.target
end

vim.api.nvim_create_user_command("IronTmuxPane", tmux.set_target, {})
vim.keymap.set("n", "<leader>s-", "<cmd>IronTmuxPane<cr>")

local cfg = {
  config = {
    scratch_repl = true,
    repl_definition = {
      python = {
        command = { "ipython", "--no-autoindent" },
        format = common.bracketed_paste_python,
        send = common.send_paste,
        block_dividers = { "# %%", "#%%" },
      },
      sh = { command = { "bash" }, block_dividers = { "# %%", "#%%" } },
      r = { command = { "R" }, block_dividers = { "# %%", "#%%" } },
    },
    repl_open_cmd = nvim_cmd,
  },
  keymaps = {
    send_motion = "<leader>sc",
    visual_send = "<leader>sc",
    send_file = "<leader>sf",
    send_line = "<leader>sl",
    send_paragraph = "<leader>sp",
    send_until_cursor = "<leader>su",
    send_mark = "<leader>sm",
    send_code_block = "<leader>sb",
    send_code_block_and_move = "<leader>sn",
    mark_motion = "<leader>mc",
    mark_visual = "<leader>mc",
    remove_mark = "<leader>md",
    cr = "<leader>s<cr>",
    interrupt = "<leader>s<leader>",
    exit = "<leader>sq",
    clear = "<leader>cl",
  },
  highlight = { italic = true },
  ignore_blank_lines = true,
}

local nvim_backend = {
  command = { "ipython", "--no-autoindent" },
  format = common.bracketed_paste_python,
  block_dividers = { "# %%", "#%%" },
}

local tmux_backend = {
  command = { "true" },
  format = function(lines)
    return table.concat(lines, "\n") .. "\n"
  end,
  block_dividers = { "# %%", "#%%" },
}

cfg.config.repl_definition.python = nvim_backend
iron.setup(cfg)

vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>")
vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>")

vim.api.nvim_create_user_command("IronUseNvim", function()
  cfg.config.repl_definition.python = nvim_backend
  cfg.config.repl_open_cmd = nvim_cmd
  iron.send = default_send
  iron.setup(cfg)
  vim.notify "Iron -> Neovim-native IPython"
end, {})

vim.api.nvim_create_user_command("IronUseTmux", function()
  if not tmux.set_target() then
    return
  end

  cfg.config.repl_definition.python = tmux_backend
  cfg.config.repl_open_cmd = function() end
  iron.send = function(_, lines)
    for _, line in ipairs(lines) do
      if not line:match "^%s*$" then
        vim.fn.jobstart { "tmux", "send-keys", "-t", tmux.target, line, "Enter" }
      end
    end
  end
  iron.setup(cfg)
  vim.notify "Iron -> tmux-based IPython"
end, {})

vim.keymap.set("n", "<leader>s.", "<cmd>IronUseTmux<cr>")
vim.keymap.set("n", "<leader>s,", "<cmd>IronUseNvim<cr>")
