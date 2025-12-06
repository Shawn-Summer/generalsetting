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
local lazy_config = {
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
    -- url_format = "https://github.com/%s.git", -- 这里的%s 表示插件的名字例如 nvim-treesitter/nvim-treesitter
    url_format = "https://gh-proxy.org/https://github.com/%s.git", -- 可以使用这样的加速GitHub镜像站
    -- 冷却时间
    cooldown = 60,
  },
  -- 及时获取更新并通知
  checker = {
    enabled = false, -- 不自动插件更新
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
}

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" }, -- lazzyvim 自带插件
    -- import/override with your plugins
    { import = "plugins" }, -- 从plugins文件夹内引入的配置
    { import = "plugins/nvim-cmp" },
    { import = "plugins/nvim-lspconfig" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
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
}, lazy_config)
