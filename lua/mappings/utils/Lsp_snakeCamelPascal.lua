local function detect_case(word)
  if word:match "^[a-z0-9]+_[a-z0-9_]+$" then
    return "snake_case"
  elseif word:match "^[a-z][a-z0-9]*[A-Z][A-Za-z0-9]*$" then
    return "camelCase"
  elseif word:match "[A-Z][a-z0-9]*[A-Z][A-Za-z0-9]*$" then
    return "PascalCase"
  end
  return nil
end

local function to_snake_case(word)
  return word:sub(1, 1):lower() .. word:sub(2):gsub("([A-Z])", "_%1"):lower()
end

local function to_camel_case(word)
  return word:sub(1, 1):lower() .. word:sub(2):gsub("_([a-z0-9])", function(c)
    return c:upper()
  end)
end

local function to_pascal_case(word)
  local camel = to_camel_case(word)
  return camel:sub(1, 1):upper() .. camel:sub(2)
end

local function convert_case()
  local word = vim.fn.expand "<cword>"
  local current = detect_case(word)

  if current == nil then
    vim.notify(word .. "Not a valid naming convention", vim.log.levels.WARN)
    return
  end

  local choices = { "snake_case", "camelCase", "PascalCase" }
  vim.ui.select(choices, { prompt = current .. "detected. Convert to:" }, function(choice)
    if not choice then
      return
    end

    local conversions = {
      ["snake_case"] = to_snake_case(word),
      ["camelCase"] = to_camel_case(word),
      ["PascalCase"] = to_pascal_case(word),
    }

    local new_word = conversions[choice]
    if new_word ~= word then
      vim.lsp.buf.rename(new_word)
    end
  end)
end

vim.keymap.set("n", "<leader>rc", convert_case, { noremap = true, desc = "Convert variable case" })
