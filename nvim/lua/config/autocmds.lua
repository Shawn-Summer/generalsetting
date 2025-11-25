-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- set osc52 for clipboard sync
--
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
    local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
    copy_to_unnamedplus(vim.v.event.regcontents)
    local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
    copy_to_unnamed(vim.v.event.regcontents)
  end,
})

-- 在 conform.nvim 配置文件或 autocmd 配置段中添加
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if not vim.g.format_on_save then
      return
    end
    local bufnr = args.buf
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")

    -- 1. 获取 conform 格式化工具列表
    local formatters = require("conform").list_formatters_to_run(bufnr)
    local formatter_names = vim.tbl_map(function(fmt)
      return fmt.name
    end, formatters)
    local formatter_str = table.concat(formatter_names, ", ")

    -- 2. 获取活跃的 LSP 客户端名称
    local active_lsps = vim.tbl_map(function(client)
      return client.name
    end, vim.lsp.get_active_clients({ bufnr = bufnr }))
    local lsp_str = table.concat(active_lsps, ", ")

    -- 3. 输出格式化开始提示
    if #formatter_names > 0 then
      vim.notify(string.format("formatting %s with %s", filename, formatter_str), vim.log.levels.INFO)
    else
      -- 显示将使用的 LSP 名称
      if #active_lsps > 0 then
        vim.notify(
          string.format("No formatters available for %s, trying LSP: %s", filename, lsp_str),
          vim.log.levels.INFO
        )
      else
        vim.notify(string.format("No formatters or LSP available for %s", filename), vim.log.levels.WARN)
      end
    end

    -- 4. 执行格式化（带 LSP 回退）
    local success = require("conform").format({
      bufnr = bufnr,
      lsp_format = "fallback",
    })

    -- 5. 输出完成提示（区分 conform 和 LSP）
    if success then
      if #formatter_names > 0 then
        vim.notify(string.format("%s formatted with %s", filename, formatter_str), vim.log.levels.INFO)
      elseif #active_lsps > 0 then
        vim.notify(string.format("%s formatted with LSP: %s", filename, lsp_str), vim.log.levels.INFO)
      end
    end
  end,
})
