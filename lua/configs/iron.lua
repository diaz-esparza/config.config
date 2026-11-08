local iron = require "iron.core"
local view = require "iron.view"
local common = require "iron.fts.common"

local og_send = iron.send
local nvim_cmd = view.bottom(20)

local tmux = {}

local function choose_tmux_pane()
  local panes_raw = vim.fn.systemlist "tmux list-panes -a -F '#S:#I.#P #{pane_id}'"
  if #panes_raw == 0 then
    vim.notify("No tmux panes found", vim.log.levels.ERROR)
    return nil
  end

  local choices = {}
  for i, entry in ipairs(panes_raw) do
    table.insert(choices, string.format("[%d] %s", i, entry))
  end
  local idx = vim.fn.inputlist(choices)

  if idx < 1 or idx > #panes_raw then
    vim.notify("Invalid index", vim.log.levels.ERROR)
    return nil
  end

  return string.match(panes_raw[idx], "(%%[%d]+)$")
end

tmux.target = nil

function tmux.set_target()
  -- local pane = os.getenv "TMUX_PANE" or run "tmux display-message -p '#{pane_id}'"
  -- tmux.target.session = run "tmux display-message -p '#S'"
  -- tmux.target.window = run "tmux display-message -p '#I'"
  local pane = choose_tmux_pane()
  if pane == nil then
    return nil
  else
    tmux.target = pane
  end
end

vim.api.nvim_create_user_command("IronTmuxPane", tmux.set_target, {})
vim.keymap.set("n", "<leader>s-", "<cmd>IronTmuxPane<cr>")

-- function tmux.cmd()
--   if tmux.target == nil then
--     tmux.set_target()
--   end
-- end

local cfg = {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,

    repl_definition = {
      -------------- Neovim-embedded IPython --------------
      python = {
        command = { "ipython", "--no-autoindent" },
        format = common.bracketed_paste_python,
        send = common.send_paste, -- reuse the built-in send
        block_dividers = { "# %%", "#%%" },
      },
      ---------------- Other REPLs ----------------
      sh = { command = { "bash" }, block_dividers = { "# %%", "#%%" } },
      r = { command = { "R" }, block_dividers = { "# %%", "#%%" } },
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = nvim_cmd,
  },

  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
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
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true,
  },

  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

local nvim_backend = {
  -------------- Neovim-embedded IPython --------------
  command = { "ipython", "--no-autoindent" },
  format = common.bracketed_paste_python,
  block_dividers = { "# %%", "#%%" },
}

local tmux_backend = {
  -------------- TMUX-based IPython --------------
  -- no autoindent so pastes come through clean
  command = { "true" },
  format = function(lines)
    return table.concat(lines, "\n") .. "\n"
  end,
  block_dividers = { "# %%", "#%%" },
}

cfg.config.repl_definition.python = nvim_backend

iron.setup(cfg)

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>")
vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>")

-- Python preferences

vim.api.nvim_create_user_command("IronUseNvim", function()
  cfg.config.repl_definition.python = nvim_backend
  cfg.config.repl_open_cmd = nvim_cmd
  -- We restore the backend
  iron.send = og_send
  iron.setup(cfg)
  print "🔧 Iron → Neovim-native IPython"
end, {})

vim.api.nvim_create_user_command("IronUseTmux", function()
  cfg.config.repl_definition.python = tmux_backend
  -- Opening cmd
  cfg.config.repl_open_cmd = function() end
  tmux.set_target()
  -- We replace the backend
  iron.send = function(_, lines)
    vim.notify("→ sending to tmux pane", vim.log.levels.DEBUG)
    for _, line in ipairs(lines) do
      if not line:match("^%s*$") then
        -- send each line and press Enter
        vim.fn.jobstart { "tmux", "send-keys", "-t", tmux.target, line, "Enter" }
      end
    end
  end
  iron.setup(cfg)
  print "\n\n🔧 Iron → tmux-based IPython"
end, {})

vim.keymap.set("n", "<leader>s.", "<cmd>IronUseTmux<cr>")
vim.keymap.set("n", "<leader>s,", "<cmd>IronUseNvim<cr>")
