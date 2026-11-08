-- Check luarocks install
local exit_code = os.execute "luarocks list > /dev/null 2>&1"

if exit_code ~= 0 then
  vim.notify("luarocks not installed. Run:\n\nsudo apt install luarocks", vim.log.levels.ERROR)
else
  exit_code = os.execute "luarocks show magick > /dev/null 2>&1"
  if exit_code ~= 0 then
    vim.notify("magick not installed. Run:\n\nsudo luarocks install magick", vim.log.levels.ERROR)
  end
end
