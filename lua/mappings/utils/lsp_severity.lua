-- Diagnostic severity selector with custom floating window
local severities = {
  { name = "Error", value = vim.diagnostic.severity.ERROR, icon = " ", hl = "DiagnosticError" },
  { name = "Warn", value = vim.diagnostic.severity.WARN, icon = " ", hl = "DiagnosticWarn" },
  { name = "Info", value = vim.diagnostic.severity.INFO, icon = "󰋼 ", hl = "DiagnosticInfo" },
  { name = "Hint", value = vim.diagnostic.severity.HINT, icon = "󰛩 ", hl = "DiagnosticHint" },
}

local function get_severity(name)
  for _, s in ipairs(severities) do
    if s.name == name then
      return s.value
    end
  end
end

local function create_floating_window(title, callback)
  local width = 30
  local height = #severities + 2
  local buf = vim.api.nvim_create_buf(false, true)

  -- Calculate center position
  local ui = vim.api.nvim_list_uis()[1]
  local win_width = ui.width
  local win_height = ui.height

  local row = math.floor((win_height - height) / 2)
  local col = math.floor((win_width - width) / 2)

  -- Window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window-local options for NvChad aesthetics
  vim.api.nvim_set_option_value("winhl", "Normal:Normal,FloatBorder:FloatBorder", { win = win })
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  -- Populate buffer with colored lines
  local lines = {}
  local ns = vim.api.nvim_create_namespace "diagnostic_selector"

  for i, sev in ipairs(severities) do
    table.insert(lines, string.format(" %d. %s %s", i, sev.icon, sev.name))
  end

  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  -- Add colors to each line
  for i, sev in ipairs(severities) do
    vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { end_col = 5, hl_group = sev.hl })
  end

  -- Position cursor based on title (MIN = bottom, MAX = top)
  if title:match "MIN" then
    vim.api.nvim_win_set_cursor(win, { #severities, 0 })
  else
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
  end

  -- Keybindings for selection
  local function close_and_select(idx)
    local selected = severities[idx]
    vim.api.nvim_win_close(win, true)
    if selected and callback then
      callback(selected.name)
    end
  end

  -- Number key selections
  for i = 1, #severities do
    vim.keymap.set("n", tostring(i), function()
      close_and_select(i)
    end, { buffer = buf, nowait = true })
  end

  -- ESC/q to close
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })

  -- Enter on current line
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    close_and_select(line)
  end, { buffer = buf, nowait = true })

  -- j/k navigation
  vim.keymap.set("n", "j", "j", { buffer = buf, nowait = true })
  vim.keymap.set("n", "k", "k", { buffer = buf, nowait = true })

  return win, buf
end

function SetDiagnosticRange()
  local original_win = vim.api.nvim_get_current_win()
  local original_pos = vim.api.nvim_win_get_cursor(original_win)

  create_floating_window("  Select MIN severity", function(min_name)
    if not min_name then
      -- Restore cursor if cancelled
      vim.api.nvim_set_current_win(original_win)
      vim.api.nvim_win_set_cursor(original_win, original_pos)
      return
    end

    vim.api.nvim_set_current_win(original_win)
    vim.api.nvim_win_set_cursor(original_win, original_pos)

    local min_severity = get_severity(min_name)

    create_floating_window("  Select MAX severity", function(max_name)
      if not max_name then
        return
      end

      vim.api.nvim_set_current_win(original_win)
      vim.api.nvim_win_set_cursor(original_win, original_pos)

      local max_severity = get_severity(max_name)

      vim.g.lsp_severity = { min = min_severity, max = max_severity }
      vim.diagnostic.config {
        severity_sort = true,
        virtual_text = {
          severity = vim.g.lsp_severity,
       },
        signs = {
          severity = vim.g.lsp_severity,
        },
        underline = {
          severity = vim.g.lsp_severity,
        },
      }

      local notify = vim.notify or print
      notify(
        string.format("Showing %s → %s", min_name, max_name),
        vim.log.levels.INFO,
        { title = "LSP Diagnostics", icon = " " }
      )
    end)
  end)
end
