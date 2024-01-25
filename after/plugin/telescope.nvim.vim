lua << EOF
local telescope = require('telescope')

telescope.setup({
defaults = {
  file_ignore_patterns = {
    "build/"
    ".jpg"
    ".png"
    ".svg"
    ".otf"
    ".ttf"
    ".git/"
    "node_modules/"
    "deps/"
    "client/js/"
    "public/js/"
    }
  }
})
EOF
