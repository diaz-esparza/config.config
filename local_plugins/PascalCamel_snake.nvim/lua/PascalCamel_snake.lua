-- Convert the word under the cursor between naming conventions.
--
-- Local-only helper: split an identifier into words once, then join them back
-- in the requested style. Handles snake_case, UPPER_SNAKE_CASE, camelCase and
-- PascalCase, including acronyms (HTTPServer -> http_server, httpServer, ...).
local M = {}

local ORDER = { "snake_case", "camelCase", "PascalCase", "UPPER_SNAKE_CASE" }

---Split an identifier into lowercase-agnostic words.
---@param word string
---@return string[]
local function split_words(word)
  local words = {}

  for part in word:gmatch "[^_]+" do
    local current = {}
    for i = 1, #part do
      local char = part:sub(i, i)
      local prev = part:sub(i - 1, i - 1)
      local next_char = part:sub(i + 1, i + 1)
      local boundary = i > 1
          and char:match "%u"
          and (prev:match "%l" or prev:match "%d" or (prev:match "%u" and next_char:match "%l"))

      if boundary then
        words[#words + 1] = table.concat(current)
        current = {}
      end
      current[#current + 1] = char
    end

    if #current > 0 then
      words[#words + 1] = table.concat(current)
    end
  end

  return words
end

local function capitalize(word)
  return word:sub(1, 1):upper() .. word:sub(2):lower()
end

local function to_snake_case(words)
  local out = {}
  for i, word in ipairs(words) do
    out[i] = word:lower()
  end
  return table.concat(out, "_")
end

local function to_upper_snake_case(words)
  local out = {}
  for i, word in ipairs(words) do
    out[i] = word:upper()
  end
  return table.concat(out, "_")
end

local function to_camel_case(words)
  local out = { words[1]:lower() }
  for i = 2, #words do
    out[i] = capitalize(words[i])
  end
  return table.concat(out)
end

local function to_pascal_case(words)
  local out = {}
  for i, word in ipairs(words) do
    out[i] = capitalize(word)
  end
  return table.concat(out)
end

M.converters = {
  snake_case = to_snake_case,
  camelCase = to_camel_case,
  PascalCase = to_pascal_case,
  UPPER_SNAKE_CASE = to_upper_snake_case,
}

---@param word string
---@return string?
function M.detect_case(word)
  if word:match "^%u[%u%d_]*$" and word:match "_" then
    return "UPPER_SNAKE_CASE"
  elseif word:match "^%l[%l%d_]*$" and word:match "_" then
    return "snake_case"
  elseif word:match "^%l[%w]*$" and word:match "%u" then
    return "camelCase"
  elseif word:match "^%u[%w]*$" and word:match "%u%l" then
    return "PascalCase"
  end
end

function M.convert()
  local word = vim.fn.expand "<cword>"
  local current = M.detect_case(word)

  if not current then
    vim.notify(word .. ": not a valid naming convention", vim.log.levels.WARN)
    return
  end

  vim.ui.select(ORDER, { prompt = current .. " detected, convert to:" }, function(choice)
    if not choice then
      return
    end

    local new_word = M.converters[choice](split_words(word))
    if new_word ~= word then
      vim.lsp.buf.rename(new_word)
    end
  end)
end

return M
