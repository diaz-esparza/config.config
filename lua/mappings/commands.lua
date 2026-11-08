-- Tolerate the most common capitalization mistakes for :w/:q.
local aliases = {
  W = "w",
  Wq = "wq",
  WQ = "wq",
  WQa = "wqa",
  WQA = "wqa",
  Wqa = "wqa",
  Q = "q",
  Qa = "qa",
  QA = "qa",
}

for name, target in pairs(aliases) do
  vim.api.nvim_create_user_command(name, target, {})
end

vim.cmd "cabbrev w+ w"
vim.api.nvim_create_user_command("WK", "WhichKey", {})
