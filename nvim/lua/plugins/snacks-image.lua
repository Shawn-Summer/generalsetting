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
      resolve = function(path, src)
         if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
         end
      end,
    },
  },
}
