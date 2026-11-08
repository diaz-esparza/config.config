local queries = require "block_gaps.queries"

local M = {}
M.ns = vim.api.nvim_create_namespace "block_gaps"

local MAX_LINES = 5000
local HL = "BlockGap"
local FILL, CORNER, DOT = "─", "╰", "╶"

function M.clear(buf)
  vim.api.nvim_buf_clear_namespace(buf, M.ns, 0, -1)
end

local function gap_width(buf)
  local textwidth = vim.bo[buf].textwidth
  return textwidth > 0 and textwidth or math.min(vim.o.columns, 120)
end

local function rule(indent, room)
  if room < 1 then
    return indent
  end
  if indent == "" then
    return FILL:rep(room)
  end
  return indent .. CORNER .. FILL:rep(room - 1)
end

local function dots(indent, room)
  if room < 1 then
    return indent
  end
  return indent .. (DOT .. " "):rep(math.floor(room / 2))
end

local function is_blank_or_comment(line)
  return not line:match "%S" or line:match "^%s*[#@]"
end

local function add_gap(buf, row, text, above)
  vim.api.nvim_buf_set_extmark(buf, M.ns, row, 0, {
    virt_lines = { { { text, HL } } },
    virt_lines_above = above,
  })
end

function M.render(buf)
  M.clear(buf)

  if vim.b[buf].block_gaps_paused then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines > MAX_LINES then
    return
  end

  local parser = vim.treesitter.get_parser(buf, nil, { error = false })
  if not parser then
    return
  end

  local lang = parser:lang()
  local query_string = queries[lang]
  if not query_string then
    return
  end

  local ok, query = pcall(vim.treesitter.query.parse, lang, query_string)
  if not ok then
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    return
  end

  local width = gap_width(buf)
  local dotted, ruled = {}, {}

  for _, node in query:iter_captures(tree:root(), buf, 0, -1) do
    local start_row, _, end_row = node:range()
    local indent = lines[start_row + 1]:match "^%s*"
    local room = width - vim.fn.strdisplaywidth(indent)

    -- Dotted line above the construct, unless it already follows a blank/comment line.
    if start_row > 0 and not dotted[start_row] and not is_blank_or_comment(lines[start_row]) then
      dotted[start_row] = true
      add_gap(buf, start_row, dots(indent, room), true)
    end

    if end_row < #lines - 1 and not ruled[end_row] then
      ruled[end_row] = true
      add_gap(buf, end_row, rule(indent, room), false)
    end
  end
end

return M
