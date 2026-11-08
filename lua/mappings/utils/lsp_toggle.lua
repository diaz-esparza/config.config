function ToggleDiagnostics()
  local enabled = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(enabled)
  print("Diagnostics " .. (enabled and "enabled" or "disabled"))
end
