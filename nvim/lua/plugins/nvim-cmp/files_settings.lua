return {
  "hrsh7th/nvim-cmp",
  config = function(_, opts)
    local cmp = require("cmp")
    -- 先应用全局配置
    cmp.setup(opts)

    -- 单独为markdown文件覆盖配置
    cmp.setup.filetype("markdown", {
      sources = {
        { name = "path" }, -- 仅保留路径补全源
      },
    })
  end,
}
