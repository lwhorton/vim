require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "build/",
      ".jpg",
      ".png",
      ".svg",
      ".otf",
      ".ttf",
      "%.class",
      "%.zip",
      ".git/",
      "node_modules/",
      "deps/",
      "client/js/",
      "public/js/",
      "public/dist/",
    },
    path_display = { "smart" },
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        mirror = true,
        height = 0.95,
        width = 0.9,
        prompt_position = "bottom",
        --preview_height = 0.2,
        --preview_width = 0.6,
      }
    }
  },
  pickers = {
    lsp_references = {
      path_display = { "smart" },
    },
  },
})

return {}
