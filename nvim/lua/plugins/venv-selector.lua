return {
  {
    "linux-cultist/venv-selector.nvim",
    opts = function(_, opts)
      -- 增量修改：确保 options 表存在，然后设置 debug = true
      opts.options = opts.options or {}
      opts.options.debug = true
    end,
  },
}
