-- a place to configure plugins

-- setup lsp

-- use this on_attach function to only map the following keys after the language
-- server attaches to the current buffer
local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  print("on_attach" .. client.name .. bufnr)

  -- mappings to LSP functions
  -- keymap.set not nvim_set_keymap because we're referencing functions
  vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end, { noremap=true, silent = true, buffer=bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'crrn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'crca', vim.lsp.buf.code_action, bufopts)

  -- using conjure as the repl, setup some better defaults
  vim.g["conjure#log#hud#anchor"] = "SE"
  vim.g["conjure#log#hud#width"] = 1.0 -- 0.42
  vim.g["conjure#log#hud#height"] = 0.2 -- 0.3
  vim.g["conjure#log#trim#at"] = 3000
  vim.g["conjure#log#wrap"] = false
  vim.g["conjure#extract#tree_sitter#enabled"] = false
  vim.g["conjure#extract#context_header_lines"] = 100 -- 24
  vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
  vim.g["conjure#client#clojure#nrepl#test#raw_out"] = true
  vim.g["conjure#client#clojure#nrepl#eval#print_options#length"] = 100
  vim.g["conjure#client#clojure#nrepl#eval#print_options#right_margin"] = 128

  -- kill evaluating clojure via conjure
  --TODO vim.keymap.set('n', 'ckk', vim.lsp.buf.code_action, bufopts)

  -- clojure specific awclojure.esomeness: https://clojure-lsp.io/features/#clojure-lsp-extra-commands
  if client.name == "clojure" then
    vim.keymap.set('n', 'cram', vim.lsp.buf.add_missing_libspec, bufopts)
    vim.keymap.set('n', 'crcn', vim.lsp.buf.clean_ns, bufopts)
    vim.keymap.set('n', 'crdk', vim.lsp.buf.destructure_keys, bufopts)
    vim.keymap.set('n', 'crtf', vim.lsp.buf.thread_first_all, bufopts)
    vim.keymap.set('n', 'crtl', vim.lsp.buf.thread_last_all, bufopts)
    vim.keymap.set('n', 'cruw', vim.lsp.buf.unwind_thread, bufopts)
  end

  -- formatting: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
  -- format the selection
  vim.keymap.set('v', '<Leader>fs', function() 
    vim.lsp.buf.format { 
      -- restrict formatting to the clients attached only to the current buffer
      bufnr = vim.api.nvim_get_current_buf(),
      async = false, -- make it sync for reliability
    }
  end, bufopts)

  -- format the whole file
  vim.keymap.set('n', '<Leader>fa', function() 
    vim.lsp.buf.format { 
      async = false, 
    }
  end, bufopts)

  -- make `=` use lsp formatters, not vim built-ins (for visual mode)
  local function lsp_or_indent_visual()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    -- some lsp servers/languages dont support range formatting, fall back to nvim `=`
    if #clients > 0 then
      vim.lsp.buf.format({
        async = false,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
      })
    else
      vim.cmd("normal! gv=")
    end
  end
  vim.keymap.set("x", "=", lsp_or_indent_visual, bufopts)

  -- align the selected text (EasyAlign) in visual mode
  vim.keymap.set('x', '<Leader>ft', '<Plug>(EasyAlign)')
  vim.keymap.set('n', '<Leader>ft', '<Plug>(EasyAlign)')
end

-- lsps provide different completion results depending on the capabilities of
-- the client. broadcast to the configured lsps that cmp-nvim has a bunch of
-- capabilities not implemented by native nvim. 
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- activate each LSP
-- each LSP in this list needs to be manually installed via NPM/whatever
local servers = { 
  {
    name = "clojure_lsp",
    cmd = { "clojure-lsp" },
    filetypes = { "clojure", "edn" },
    root_dir = vim.fn.getcwd(),
    settings = {
      trace_level = "verbose"
    }
  },
  { name = "jsonls"},
  { name = "eslint"},
}
for _, lsp in pairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  for k, v in pairs(lsp) do
    config[k] = v
  end
  -- for server-specific settings. see `:help lspconfig-setup`
  -- note you cannot send settings as a function to an lsp server! we use this
  -- settings object abstraction to prevent sending any baseline
  -- configurations as functions (like root_dir, filetypes) to the settings
  -- key: https://neovim.discourse.group/t/cannot-serialize-function-type-not-supported/4542/3
  vim.lsp.config(config.name, config)
  vim.lsp.enable(config.name)
end

vim.diagnostic.config({
  virtual_text = {
    prefix = "»",
    virt_text_pos = "eol",
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- order is important: 
-- 1. get a hook to luasnip
-- 2. configure cmp to use luasnip
-- load snips as needed by filetype per the folder in the config dir
local luasnip = require('luasnip')
-- setup nvim-cmd and feed it LSPs and sources
local cmp = require('cmp')
cmp.setup {
  -- if using luasnip, enable this
  snippet = {
    expand = function(args) 
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    -- use ctrl-l/h as the auto complete positional filler, with <tab> as the
    -- confirmation, and ctrl-j/k as scrolling through the completion list. 
    ["<Tab>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-l>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-h>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    -- to change priority of what shows up here, you can reorder these
    -- also, limit when a suggestion window shows up based on key length
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
  }
}

-- instead of lazy loading, we're just using a single luasnip.lua file
--require('luasnip.loaders.from_lua').lazy_load({ lazy_paths = "~/.config/nvim/lua/snippets" })
require('luasnip.loaders.from_snipmate').lazy_load({ lazy_paths = "~/.config/nvim/lua/snippets" })
luasnip.setup {
  -- allow jumping back into a snippet, even after you have exited the
  -- template
  history = true,
  -- update dynamic snippets as you type
  updateevents = "TextChanged,TextChangedI",
}

-- shortcut to reload snips 
--vim.keymap.set('n', '<leader><leader>s', function() require('luasnip.loaders').reload_file('~/.config/nvim/lua/snippets')

require('telescope').setup {
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
    path_display = {"truncate"}
  },
  pickers = {
    lsp_references = {
      path_display = {"truncate"}
    }
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "clojure", "comment" },
  indent = {
    enable = true,
  },
  highlight = {
    enable = false,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
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
}

require('kitty-scrollback').setup {
  status_window = {
    enabled = true,
    show_timer = true,
    style_simple = true,
  },
}

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
