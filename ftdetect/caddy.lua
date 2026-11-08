vim.filetype.add {
  filename = {
    Caddyfile = "caddy",
    caddyfile = "caddy",
  },
  -- Patterns are anchored and matched against the basename, so this covers
  -- Caddyfile, Caddyfile.dev, caddyfile.json, my.caddyfile and foo-Caddyfile.
  pattern = {
    [".*[Cc]addyfile.*"] = "caddy",
  },
}
