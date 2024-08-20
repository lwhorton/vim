-- a place to configure plugins

-- setup lsp

-- use this on_attach function to only map the following keys after the language
-- server attaches to the current buffer
local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }

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

  -- clojure specific awesomeness: https://clojure-lsp.io/features/#clojure-lsp-extra-commands
  if client.name == "clojure" then
    vim.keymap.set('n', 'cram', vim.lsp.buf.add_missing_libspec, bufopts)
    vim.keymap.set('n', 'crcn', vim.lsp.buf.clean_ns, bufopts)
    vim.keymap.set('n', 'crdk', vim.lsp.buf.destructure_keys, bufopts)
    vim.keymap.set('n', 'crtf', vim.lsp.buf.thread_first_all, bufopts)
    vim.keymap.set('n', 'crtl', vim.lsp.buf.thread_last_all, bufopts)
    vim.keymap.set('n', 'cruw', vim.lsp.buf.unwind_thread, bufopts)
  end

  -- formatting: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
  vim.keymap.set('v', '<Leader>fs', function() 
    vim.lsp.buf.format { 
      -- restrict formatting to the clients attached only to the current buffer
      bufnr = bufnr,
      async = true, 
      -- by default range is current selection in v-mode
      --range = { 
        --["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        --["end"] = vim.api.nvim_buf_get_mark(0, ">"),
      --} 
    }
  end, bufopts)

  -- format the whole file
  vim.keymap.set('n', '<Leader>fa', function() vim.lsp.buf.format { async = false } end, bufopts)
  vim.keymap.set('v', '<Leader>fa', function() vim.lsp.buf.format { async = false } end, bufopts)

  --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
end

-- lsps provide different completion results depending on the capabilities of
-- the client. broadcast to the configured lsps that cmp-nvim has a bunch of
-- capabilities not implemented by native nvim. 
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.formatting = true
capabilities.textDocument.rangeFormatting = true
capabilities.textDocument.range_formatting = true

-- activate each LSP
-- each LSP in this list needs to be manually installed via NPM/whatever
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local servers = { 
  {'clojure_lsp', {
    cmd = { "clojure-lsp" },
    filetypes = { "clojure", "edn" },
    root_dir = util.root_pattern("project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", "bb.edn"),
    settings = {
      trace_level = verbose
    }
  }},
  --{'tsserver', {
    --filetypes = {'javascript', 'javascriptreact', 'typescript'}
  --}},
  {'jsonls', {}},
  {'eslint', {}},
  --{'tailwindcss', {}},
}
for _, lsp in pairs(servers) do
  lspconfig[lsp[1]].setup {
    on_attach = on_attach,
    capabilites = capabilities,
    -- for server-specific settings. see `:help lspconfig-setup`
    -- note you cannot send settings as a function to an lsp server! we use this
    -- settings object abstraction to prevent sending any baseline
    -- configurations as functions (like root_dir, filetypes) to the settings
    -- key: https://neovim.discourse.group/t/cannot-serialize-function-type-not-supported/4542/3
    settings = (lsp[2] or {}).settings
  }
end

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
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,

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

-- setup debugger in node
-- this dap-vscode-js is a wrapper around the shitty vscode-js-debug
--require('dap-vscode-js').setup({
--  --node_path = "/Users/luke/.asdf/shims/node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--  -- Path to vscode-js-debug installation.
--  debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. "/lazy/vscode-js-debug"),
--  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
--  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
--  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
--  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
--  -- })
--})
--
--for _, language in ipairs({ "typescript", "javascript" }) do
--  require("dap").configurations[language] = {
--    --https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md
--    --https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/
--    --https://github.com/anasrar/.dotfiles/blob/4c444c3ab2986db6ca7e2a47068222e47fd232e2/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua
--    {
--      -- https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_source-maps
--      type = 'pwa-node',
--      request = 'attach',
--      name = 'Attach automatically',
--      cwd = vim.fn.getcwd(),
--      autoAttachChildProcesses = true,
--      attachExistingChildren = true,
--      continueOnAttach = false,
--      --protocol = 'inspector',
--      -- node --inspect defaults
--      --hostname = '127.0.0.1',
--      --port = 9222,
--      --
--      outputCapture = 'console', -- or 'std'
--      trace = true,
--      --console = 'externalTerminal',
--      sourceMaps = false,
--      resolveSourceMapLocations = {
--        "${workspaceFolder}/**",
--        "!**/node_modules/**",
--      },
--      skipFiles = { 
--        '<node_internals>/**',
--        "${workspaceFolder}/node_modules/**",
--      },
--      --restart = {
--        --delay = 1,
--        --maxAttempts = 10,
--      --},
--    },
--    {
--      type = "pwa-node",
--      request = "attach",
--      name = "Attach manually",
--      cwd = vim.fn.getcwd(),
--      processId = require'dap.utils'.pick_process,
--      autoAttachChildProcesses = true,
--      attachExistingChildren = true,
--      continueOnAttach = false,
--      resolveSourceMapLocations = {
--        "${workspaceFolder}/**",
--        "!**/node_modules/**",
--      },
--      --skipFiles = { '**/node_modules/**' },
--    },
--    {
--      type = "pwa-node",
--      request = "attach",
--      name = "Attach manually at a non-default inspector",
--      processId = require'dap.utils'.pick_process,
--      port = function()
--        local co = coroutine.running()
--        return coroutine.create(function()
--          vim.ui.input({
--            prompt = "Enter port: ",
--          }, function(port)
--            if port == nil or port == "" then
--              return
--            else
--              coroutine.resume(co, port)
--            end
--          end)
--        end)
--      end,
--      hostname = function()
--        local co = coroutine.running()
--        return coroutine.create(function()
--          vim.ui.input({
--            prompt = "Enter hostname: ",
--            default = "127.0.0.1",
--          }, function(hostname)
--            if hostname == nil or hostname == "" then
--              return
--            else
--              coroutine.resume(co, hostname)
--            end
--          end)
--        end)
--      end,
--    },
--
--    --{
--      --type = "pwa-node",
--      --request = "launch",
--      --name = "Launch current file",
--      --program = "${file}",
--      --cwd = vim.fn.getcwd(),
--      --sourceMaps = true,
--      --skipFiles = { '**/node_modules/**' },
--    --},
--    ---- TODO:debug via chrome (client side)
--    --{
--      --type = "pwa-chrome",
--      --request = "launch",
--      --name = "Launch & debug with chrome (arc?) devtools inspector",
--      --skipFiles = { '**/node_modules/**' },
--      --url = function()
--        --local co = coroutine.running()
--        --return coroutine.create(function()
--          --vim.ui.input({
--            --prompt = "Enter URL: ",
--            --default = "http://localhost:8080",
--          --}, function(url)
--            --if url == nil or url == "" then
--              --return
--            --else
--              --coroutine.resume(co, url)
--            --end
--          --end)
--        --end)
--      --end,
--      --webRoot = vim.fn.getcwd(),
--      --protocol = "inspector",
--      --sourceMaps = true,
--      --userDataDir = false,
--    --},
--  }
--end
--
---- automatically toggle the dap-ui on attach 
--local dap, dapui = require("dap"), require("dapui")
--dap.set_log_level('TRACE')
--dap.listeners.before.attach.dapui_config = function()
--  dapui.open()
--end
--dap.listeners.before.launch.dapui_config = function()
--  dapui.open()
--end
--dap.listeners.before.event_terminated.dapui_config = function()
--  dapui.close()
--end
--dap.listeners.before.event_exited.dapui_config = function()
--  dapui.close()
--end
--
---- keymaps for dap debugging
--vim.keymap.set('n', '<Leader>dj', function() require('dap').step_over() end)
--vim.keymap.set('n', '<Leader>dl', function() require('dap').step_into() end)
--vim.keymap.set('n', '<Leader>dk', function() require('dap').continue() end)
--vim.keymap.set('n', '<Leader>dh', function() require('dap').step_out() end)
--vim.keymap.set('n', '<Leader>dc', function() require('dap').run_to_cursor() end)
--vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
--vim.keymap.set('n', '<Leader>da', function() require('dap').continue({ before = get_args }) end)
--vim.keymap.set('n', '<Leader>dq', function() require('dap').disconnect() end)
--vim.keymap.set('n', '<Leader>dQ', function() require('dapui').close() end)
--vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
--vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
--vim.keymap.set('n', '<Leader>dp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
--vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
--  require('dap.ui.widgets').preview()
--end)
--vim.keymap.set('n', '<Leader>df', function()
--  local widgets = require('dap.ui.widgets')
--  widgets.centered_float(widgets.frames)
--end)
--vim.keymap.set('n', '<Leader>ds', function()
--  local widgets = require('dap.ui.widgets')
--  widgets.centered_float(widgets.scopes)
--end)

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
