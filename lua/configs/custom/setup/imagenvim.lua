-- Legacy image.nvim setup
--
-- require("image").setup {
--   render = {
--     min_padding = 5,
--     show_label = true,
--     show_image_dimensions = true,
--     use_dither = true,
--     foreground_color = true,
--     background_color = true,
--   },
--   events = {
--     update_on_nvim_resize = true,
--   },
-- }

-- New image.nvim jank!
require("image").setup {
  backend = "kitty",
  processor = "magick_rock", -- or "magick_cli"
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      only_render_image_at_cursor_mode = "popup",
      floating_windows = false,              -- if true, images will be rendered in floating markdown windows
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = true,
      filetypes = { "norg" },
    },
    typst = {
      enabled = true,
      filetypes = { "typst" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
  editor_only_render_when_focused = true,                                             -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false,                                            -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
}

vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  callback = function(ev)
    vim.schedule(function()
      local img = require("image").from_file(ev.file)
      if img then
        img:render()
        -- Disable editing on this buffer
        vim.bo[ev.buf].modifiable = false
        vim.bo[ev.buf].readonly = true
        vim.bo[ev.buf].filetype = "image"

        -- Map 'q' in normal mode to close the window forcefully
        vim.api.nvim_buf_set_keymap(ev.buf, "n", "q", ":q!<CR>", { silent = true, nowait = true, noremap = true })
      else
        vim.notify("Failed to render image: " .. ev.file, vim.log.levels.ERROR)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("BufUnload", {
  pattern = "*.png,*.jpg,*.jpeg,*.gif,*.webp,*.avif",
  callback = function()
    require("image").clear()
  end,
})

-- Useful commands

vim.api.nvim_create_user_command("ImageOpen", function(opts)
  local path = vim.fn.expand(opts.args)
  local img = require("image").from_file(path)
  if not img then
    vim.notify("Failed to load image: " .. path, vim.log.levels.ERROR)
    return
  end
  img:render()
end, { nargs = 1, complete = "file" })

vim.api.nvim_create_user_command("ImageClear", function()
  require("image").clear() -- remove all rendered images
end, {})

vim.api.nvim_create_user_command("ImageFloatOpen", function(opts)
  local img = require("image").from_file(opts.args)
  if img then
    img:open_float { border = "rounded", max_width = 80, max_height = 40 }
  end
end, { nargs = 1, complete = "file" })

-- Useful shortcuts

vim.keymap.set("n", "<leader>ic", ":ImageClear<CR>", { desc = "Clear inline images" })

vim.keymap.set("n", "<leader>ip", function()
  require("telescope.builtin").find_files {
    prompt_title = "Find Image",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        vim.cmd("ImageOpen " .. selection.path)
      end)
      return true
    end,
  }
end, { desc = "Pick and open image" })
