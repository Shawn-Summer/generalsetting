return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  event = {
    -- 匹配 MyNotes 工作区内所有 .md 文件（包括子目录）
    "BufReadPre ~/MyNotes/MyNotes/**/*.md",
    "BufNewFile ~/MyNotes/MyNotes/**/*.md",
  },
  -- 基础静态配置（只定义不变的部分）
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/MyNotes/MyNotes",
      },
    },
    legacy_commands = false,
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    statusline = {
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      enabled = false,
    },

    daily_notes = {
      folder = "Daily",
      default_tags = { "daily-notes" },
      workdays_only = false,
      template = "Daily.md",
    },
    attachments = {
      confirm_img_paste = false,
    },
    frontmatter = {
      enabled = false,
    },
    footer = {
      enabled = false,
    },
    ui = {
      enable = false, -- 和 render-markdown conflicts
    },
  },
  config = function(_, opts)
    -- 1. 初始化插件（先加载基础配置）
    local obsidian = require("obsidian")
    obsidian.setup(opts)
    if not opts.attachments then
      opts.attachments = {}
    end
    -- 2. 定义「更新 img_folder」的核心函数
    local function update_obsidian_img_folder()
      -- 只处理 Markdown 文件（避免非笔记文件触发）
      local filetype = vim.bo.filetype
      if filetype ~= "markdown" then
        return
      end

      -- 获取当前打开的笔记文件（此时 buffer 已经是 .md 文件，不会是 MyNotes）
      local current_buffer_path = vim.api.nvim_buf_get_name(0)
      local current_buffer_name = vim.fn.fnamemodify(current_buffer_path, ":t:r")

      -- 动态更新 attachments.img_folder（拼接完整路径）
      opts.attachments.img_folder = "./" .. current_buffer_name
      -- 重新应用配置（obsidian 支持热更新）
      obsidian.setup(opts)
    end

    -- 3. 注册自动命令：监听「打开/切换 buffer」事件
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md", -- 只对 .md 文件生效（精准触发）
      callback = update_obsidian_img_folder, -- 触发时执行更新函数
      group = vim.api.nvim_create_augroup("ObsidianDynamicImgFolder", { clear = true }),
    })

    -- 4. 初始打开 Neovim 时，若当前已是 .md 文件，手动触发一次更新
    update_obsidian_img_folder()
  end,
}
