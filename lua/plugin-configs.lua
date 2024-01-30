-- a place to configure plugins

--require('NeoSolarized').setup {
  --style = "dark", -- "dark" or "light"
  --transparent = false, -- true/false; Enable this to disable setting the background color
  --terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  --enable_italics = true, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
  --styles = {
    ---- Style to be applied to different syntax groups
    --comments = { italic = true },
    --keywords = { italic = true },
    --functions = { bold = true },
    --variables = {},
    --string = { italic = true },
    --underline = true, -- for global underline
    --undercurl = true, -- for global undercurl
  --},
  ---- Add specific hightlight groups
  --on_highlights = function(highlights, colors) 
    ---- highlights.Include.fg = colors.red -- Using `red` foreground for Includes
  --end, 
--}
-- config has to be done BEFORE loading the colorscheme
--vim.cmd('colorscheme NeoSolarized')

--require('neo-tree').setup {
  --close_if_last_window = false,
  --enable_git_status = true,
  --sort_case_insensitive = false,
  --event_handlers = {
    --{
      --event = "file_opened",
      --handler = function(file_path) 
        ---- auto close the file tree when we open a file
        --require("neo-tree.command").execute({ action = "close" })
      --end
    --}
  --},
  --filesystem = {
    --window = {
      --mappings = {
        --["-"] = "navigate_up",
        --["<C-c>"] = "clear_filter",
      --}
    --},
    --filtered_items = {
      --visible = false,
      --hide_dotfiles = false,
      --hide_gitignored = false,
    --},
    --follow_current_file = {
      --enabled = false,
      --leave_dirs_open = false,
    --},
  --},
  --buffers = {
    --follow_current_file = {
      --enabled = false,
      --leave_dirs_open = false,
    --},
  --},
  --icon = {
    --folder_closed = "",
    --folder_open = "",
    --folder_empty = "󰜌",
    ---- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
    ---- then these will never be used.
    --default = "*",
    --highlight = "NeoTreeFileIcon"
  --},
  --modified = {
    --symbol = "[+]",
    --highlight = "NeoTreeModified",
  --},
--}

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
      "public/dist/",
    },
  },
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

require('kitty-scrollback').setup {
  status_window = {
    enabled = true,
    show_timer = true,
    style_simple = true,
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

-- from a quickfix window, open file under cursor vertically or horizontally
-- (like splits)
vim.g.qfenter_keymap = {}
vim.g.qfenter_keymap.open = {'<CR>'}
vim.g.qfenter_keymap.hopen = {'<leader>j'}
vim.g.qfenter_keymap.vopen = {'<leader>k'}
