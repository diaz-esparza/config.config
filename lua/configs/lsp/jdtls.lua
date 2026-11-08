-- JAVA
-- different because it's loaded separately

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",

  callback = function()
    local jdtls = require "jdtls"
    -- Detect project root
    local root_dir = require("jdtls.setup").find_root { "gradlew", ".git", "mvnw" }

    -- Workspace folder for jdtls cache
    local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    local config = {
      cmd = {
        vim.fn.stdpath "data" .. "/mason/bin/jdtls",
        "-data",
        workspace_dir,
      },
      root_dir = root_dir,
      on_attach = function(client, bufnr)
        -- Enable code actions
        client.server_capabilities.codeActionProvider = true
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
      end,
    }

    -- Formatting
    vim.opt.shiftwidth = 2

    -- Start or attach jdtls
    jdtls.start_or_attach(config)
  end,
})
