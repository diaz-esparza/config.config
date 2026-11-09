local core = require "block_gaps.core"

local M = { enabled = false }
local timer = assert(vim.uv.new_timer())

local function each_loaded_buf(fn)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      fn(buf)
    end
  end
end

local function draw(buf)
  if M.enabled then
    core.render(buf)
  end
end

function M.setup()
  vim.api.nvim_set_hl(0, "BlockGap", { fg = "#2a3142" })

  local group = vim.api.nvim_create_augroup("BlockGaps", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    group = group,
    callback = function(args)
      draw(args.buf)
    end,
  })

  -- Re-parsing on every keystroke is wasteful; wait for typing to settle.
  vim.api.nvim_create_autocmd("TextChanged", {
    group = group,
    callback = function(args)
      timer:stop()
      timer:start(
        150,
        0,
        vim.schedule_wrap(function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            draw(args.buf)
          end
        end)
      )
    end,
  })
end

function M.enable()
  M.enabled = true
  M.refresh()
end

function M.disable()
  M.enabled = false
  each_loaded_buf(core.clear)
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

function M.refresh()
  if not M.enabled then
    return
  end
  each_loaded_buf(function(buf)
    -- Also resumes buffers paused by :BlockGapsBake.
    vim.b[buf].block_gaps_paused = nil
    core.render(buf)
  end)
end

local function virtual_text(virt_lines)
  local text = {}
  for _, line in ipairs(virt_lines) do
    local chunks = {}
    for _, chunk in ipairs(line) do
      chunks[#chunks + 1] = chunk[1]
    end
    text[#text + 1] = table.concat(chunks)
  end
  return text
end

function M.bake()
  local buf = vim.api.nvim_get_current_buf()
  local marks = vim.api.nvim_buf_get_extmarks(buf, core.ns, 0, -1, { details = true })
  if #marks == 0 then
    vim.notify("No block gaps to bake", vim.log.levels.INFO)
    return
  end

  local above, below = {}, {}
  for _, mark in ipairs(marks) do
    local row, details = mark[2], mark[4]
    if details and details.virt_lines then
      local into = details.virt_lines_above and above or below
      into[row] = into[row] or {}
      vim.list_extend(into[row], virtual_text(details.virt_lines))
    end
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local baked = {}
  for i, line in ipairs(lines) do
    vim.list_extend(baked, above[i - 1] or {})
    baked[#baked + 1] = line
    vim.list_extend(baked, below[i - 1] or {})
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, baked)
  vim.api.nvim_win_set_cursor(0, cursor)

  -- The gaps are real lines now; don't draw them again on top.
  vim.b[buf].block_gaps_paused = true
  core.clear(buf)
end

return M
