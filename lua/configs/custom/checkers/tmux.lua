-- Check tmux config ONLY IF IN TMUX
if vim.env.TMUX ~= nil then
  local function tmux_opt(opt)
    return vim.fn.system("tmux show -gqv " .. opt):gsub("%s+", "")
  end

  local passthrough = tmux_opt "allow-passthrough"
  local visual = tmux_opt "visual-activity"

  if passthrough ~= "on" or visual ~= "off" then
    local answer = vim.fn.input(string.format(
      [[One or both tmux options are incorrectly set.
    - allow-passthrough is '%s', should be 'on'
    - visual-activity is '%s', should be 'off'

  Correct this? [y/N]: ]],
      passthrough,
      visual
    ))
    if answer:lower() == "y" then
      print "Installing..."
      os.execute "tmux set -gq allow-passthrough on"
      os.execute "tmux set -gq visual-activity off"
    else
      print "Canceled."
    end
  else
  end
end
