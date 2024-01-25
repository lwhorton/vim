lua <<EOF
require'nvim-treesitter.configs'.setup {
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        [">e"] = "@parameter.inner",
      },
      swap_previous = {
        ["<e"] = "@parameter.inner",
      },
    },
  },
}
EOF
