-- a place to configure plugins

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "build/",
      ".jpg",
      ".png",
      ".svg",
      ".otf",
      ".ttf",
      ".git/",
      "node_modules/",
      "deps/",
      "client/js/",
      "public/js/",
    }
  }
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  -- give other languages lisp-ey structural editing: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
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

-- vim-clojure-static
vim.g.clojure_fuzzy_indent_patterns = {
    '^doto', '^with', '^def', '^let', 'go-loop', 'match', '^context', '^GET', '^PUT', '^POST', '^PATCH', '^DELETE', '^ANY', 'this-as', '^are', '^dofor', 'attempt-all', 'when-failed'
}
vim.g.clojure_align_multiline_strings = 1

-- airline
-- still render status if only 1 file is open
vim.opt.laststatus = 2
vim.g.airline_section_a = vim.fn['airline#section#create_left']({'mode'})
vim.g.airline_section_b = '%-0.30{getcwd()}'
vim.g.airline_section_c = '%t'
vim.g.airline_section_gutter = ''
vim.g.airline_section_x = ''
vim.g.airline_section_y = ''
vim.g.airline_section_z = vim.fn['airline#section#create_right']({'%3p%%', '%l/%L'})
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
vim.g['airline#extensions#branch#enabled'] = 0
vim.g['airline#extensions#tabline#fnamecollapse'] = 0

-- disable auto-insert / auto-delete mode for clojure expressions
vim.g.sexp_enable_insert_mode_mappings = 0

-- enable html/css highlighting in js files
vim.g.javascript_enable_domhtmlcss = 1

-- change git-gutter's gutter background color
vim.cmd('highlight clear SignColumn')
vim.g.gitgutter_override_sign_column_highlight = 0

-- lexima
-- dont auto-insert closing units for stringy things (super annoying)
vim.fn['lexima#add_rule']({char = '"', input_after = ''})
vim.fn['lexima#add_rule']({char = '""', input_after = ''})
vim.fn['lexima#add_rule']({char = "'", input_after = ''})
vim.fn['lexima#add_rule']({char = "''", input_after = ''})
vim.fn['lexima#add_rule']({char = "``", input_after = ''})

-- vim-matchup
-- performance limiters 
vim.g.matchup_delim_stopline = 25000 -- for all matches 
vim.g.matchup_matchparen_stopline = 400 -- for match highlighting only

-- from quickfix window, open file under cursor vertically/horizontally
vim.g.qfenter_keymap = {}
vim.g.qfenter_keymap.open = ['<CR>']
vim.g.qfenter_keymap.hopen = ['<leader>j']
vim.g.qfenter_keymap.vopen = ['<leader>k']