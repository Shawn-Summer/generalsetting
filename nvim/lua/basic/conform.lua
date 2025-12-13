return {
  "stevearc/conform.nvim",
  opts = {
    -- 只添加这一行，其他配置会自动继承（如 formatters_by_ft、formatters 等）
    -- 关掉只使用自己写的 format_on_save
    format_on_save = nil,
    format_after_save = nil,
  },
}
