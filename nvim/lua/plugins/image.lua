return {
  {
    "3rd/image.nvim",
    enabled = false,
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      backend = "kitty", -- or "ueberzug" or "sixel"
      processor = "magick_cli", -- or "magick_rock"
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup", -- or "inline"
          floating_windows = false, -- if true, images will be rendered in floating markdown windows
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
          resolve_image_path = function(document_path, image_path, fallback)
            -- 提取图片文件名（如从 "abc.png" 或 "[[abc.png]]" 中获取 "abc.png"）
            -- 获取当前 markdown 文件（abc.md）的父文件夹路径
            -- document_path 是文件绝对路径
            -- image_path 图片路径
            local parent_dir = vim.fn.fnamemodify(document_path, ":h") -- 文件父路径
            local doc_filename = vim.fn.fnamemodify(document_path, ":t:r") -- 文件名（去掉后缀）
            -- 定义要搜索的 3 种路径
            local search_paths = {
              -- 1. abc.md 的父文件夹（直接在父目录找图片）
              parent_dir
                .. "/"
                .. image_path,

              -- 2. 父文件夹下的 abc/ 目录（如 /path/to/parent/abc/abc.png）
              parent_dir
                .. "/"
                .. doc_filename
                .. "/"
                .. image_path,

              -- 3. 父文件夹下的 assets/abc/ 目录（如 /path/to/parent/assets/abc/abc.png）
              parent_dir
                .. "/assets/"
                .. doc_filename
                .. "/"
                .. image_path,
            }

            -- 按顺序检查路径是否存在，返回第一个找到的有效路径
            for _, path in ipairs(search_paths) do
              if vim.fn.filereadable(path) == 1 then -- 检查文件是否存在且可读
                return path
              end
            end

            -- 如果都找不到，使用默认逻辑（fallback）
            return fallback(document_path, image_path)
          end,
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
      scale_factor = 1.0,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
  },
}
