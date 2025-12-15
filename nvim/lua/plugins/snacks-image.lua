return {
  "folke/snacks.nvim",
  opts = {
    styles = {
        -- INFO: 在右上角显示图片
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
    image = {
      enabled = true,
      doc = {
        inline = false,
        max_width = 45,
        max_height = 20,
      },
    },
  },
}
