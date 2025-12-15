local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec = {
  -- LazyVim 核心插件 共享(基础)插件只
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "basic" },
  { import = "basic/nvim-cmp" },
  { import = "basic/nvim-lspconfig" },
}

vim.g.old_version = (os.getenv("SSH_IDENTITY") == "xxl")
-- 2. 根据 vim.g.old_version 条件追加导入
if vim.g.old_version == true then
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.python" })
  table.insert(spec, { import = "old_version" })
else
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.python" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.tex" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.git" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.clangd" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.json" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.yaml" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.toml" })
  table.insert(spec, { import = "lazyvim.plugins.extras.lang.docker" })
  table.insert(spec, { import = "lazyvim.plugins.extras.coding.yanky" })
  table.insert(spec, { import = "lazyvim.plugins.extras.ui.smear-cursor"})
  table.insert(spec, { import = "lazyvim.plugins.extras.formatting.prettier" })
  table.insert(spec, { import = "lazyvim.plugins.extras.util.mini-hipatterns"})
  table.insert(spec, { import = "lazyvim.plugins.extras.util.startuptime"})
  table.insert(spec, { import = "lazyvim.plugins.extras.vscode"})
  table.insert(spec, { import = "plugins" })
end

require("lazy").setup({
  spec = spec,
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = "*", -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
 
  -- 网络控制相关
  git = {
    -- 网络节流控制 单位时间内的 Git 网络操作次数(这里是 5秒 2次)
    throttle = {
      enabled = true,
      rate = 2,
      duration = 5000,
    },
    -- Git过滤器优化
    filter = true,
    -- 操作超时
    timeout = 120,
    -- CDN加速配置
    url_format = "https://github.com/%s.git", -- 这里的%s 表示插件的名字例如 nvim-treesitter/nvim-treesitter
    -- url_format = "https://gh-proxy.org/https://github.com/%s.git", -- 可以使用这样的加速GitHub镜像站
    -- 冷却时间
    cooldown = 60,
  },
  -- 及时获取更新并通知
  checker = {
    enabled = false, -- 不获得更新通知
    concurrency = 1,
    frequency = 3600,
  },
  -- 纯lua包的管理
  pkg = {
    enabled = true,
    cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
    -- the first package source that is found for a plugin will be used.
    sources = {
      "lazy",
      "rockspec", -- will only be used when rocks.enabled is true
      "packspec",
    },
  },
  rocks = {
    enabled = true,
    root = vim.fn.stdpath("data") .. "/lazy-rocks",
    server = "https://lumen-oss.github.io/rocks-binaries/",
    -- server = "https://luarocks.org/manifests/neorocks/",
    -- use hererocks to install luarocks?
    -- set to `nil` to use hererocks when luarocks is not found
    -- set to `true` to always use hererocks
    -- set to `false` to always use luarocks
    hererocks = nil,
  },
})
