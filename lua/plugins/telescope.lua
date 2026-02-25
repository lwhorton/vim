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
    path_display = { "truncate" },
  },
  pickers = {
    lsp_references = {
      path_display = { "truncate" },
    },
  },
})

return {}
