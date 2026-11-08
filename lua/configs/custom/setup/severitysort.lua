-- more jank!! ...To display linter output from
-- most to least severe

vim.diagnostic.config {
  virtual_text = {
    -- Custom handler to only show the *most severe* diag per line
    format = function(diagnostic)
      -- This function is per-diagnostic; you can customize the text here too
      return diagnostic.message
    end,
    -- Prioritize most severe
    severity_sort = true,
  },
  severity_sort = true,
}
