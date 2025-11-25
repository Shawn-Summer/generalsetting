return {

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("$HOME/.config/nvim/lua/plugins/.markdownlint-cli2.yaml"), "--" }, -- 代码质量检测
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("$HOME/.config/nvim/lua/plugins/.markdownlint-cli2.yaml"), "--" }, -- formatter
        },
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim", -- 粘贴图片
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      -- 覆盖全局默认配置
      default = {
        relative_to_current_file = true, -- 图片保存到当前编辑文件所在目录
        dir_path = function() -- 文件夹名与当前编辑文件同名
          return vim.fn.expand("%:t:r")
        end,
        prompt_for_file_name = false, -- 不提示输入文件名
      },
    },
    keys = {
      -- suggested keymap
      { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
