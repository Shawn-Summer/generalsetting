-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- support directly copy to clipboard by vim's y command. (actually lua code)
vim.opt.clipboard = "unnamedplus"

vim.opt.relativenumber = true -- use relativ number
vim.opt_local.spell = false -- disable spell check
vim.diagnostic.enable(false) 
vim.g.autoformat = false -- disable autoformat 只使用 format_on_save
---lspconfig
-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright" -- or pyright
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false

-- 全局开关：是否开启保存时自动格式化（默认开启）
vim.g.format_on_save = false
vim.api.nvim_create_user_command("FormatOnSaveToggle", function()
  vim.g.format_on_save = not vim.g.format_on_save
  local status = vim.g.format_on_save and "enabled" or "disabled"
  vim.notify("Format on save " .. status, vim.log.levels.INFO)
end, { desc = "Toggle format on save" })
