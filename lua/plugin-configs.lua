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
      "%.class",
      "%.zip",
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

-- setup debugger in node
-- this dap-vscode-js is a wrapper around the shitty vscode-js-debug
require('dap-vscode-js').setup({
  --node_path = "/Users/luke/.asdf/shims/node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  -- Path to vscode-js-debug installation.
  debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. "/lazy/vscode-js-debug"),
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
  -- })
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    --https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md
    --https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/
    --https://github.com/anasrar/.dotfiles/blob/4c444c3ab2986db6ca7e2a47068222e47fd232e2/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua
    {
      -- https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_source-maps
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach automatically',
      cwd = vim.fn.getcwd(),
      autoAttachChildProcesses = true,
      attachExistingChildren = true,
      continueOnAttach = false,
      --protocol = 'inspector',
      -- node --inspect defaults
      --hostname = '127.0.0.1',
      --port = 9222,
      --
      outputCapture = 'console', -- or 'std'
      trace = true,
      --console = 'externalTerminal',
      sourceMaps = false,
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      skipFiles = { 
        '<node_internals>/**',
        "${workspaceFolder}/node_modules/**",
      },
      --restart = {
        --delay = 1,
        --maxAttempts = 10,
      --},
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach manually",
      cwd = vim.fn.getcwd(),
      processId = require'dap.utils'.pick_process,
      autoAttachChildProcesses = true,
      attachExistingChildren = true,
      continueOnAttach = false,
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      --skipFiles = { '**/node_modules/**' },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach manually at a non-default inspector",
      processId = require'dap.utils'.pick_process,
      port = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({
            prompt = "Enter port: ",
          }, function(port)
            if port == nil or port == "" then
              return
            else
              coroutine.resume(co, port)
            end
          end)
        end)
      end,
      hostname = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({
            prompt = "Enter hostname: ",
            default = "127.0.0.1",
          }, function(hostname)
            if hostname == nil or hostname == "" then
              return
            else
              coroutine.resume(co, hostname)
            end
          end)
        end)
      end,
    },

    --{
      --type = "pwa-node",
      --request = "launch",
      --name = "Launch current file",
      --program = "${file}",
      --cwd = vim.fn.getcwd(),
      --sourceMaps = true,
      --skipFiles = { '**/node_modules/**' },
    --},
    ---- TODO:debug via chrome (client side)
    --{
      --type = "pwa-chrome",
      --request = "launch",
      --name = "Launch & debug with chrome (arc?) devtools inspector",
      --skipFiles = { '**/node_modules/**' },
      --url = function()
        --local co = coroutine.running()
        --return coroutine.create(function()
          --vim.ui.input({
            --prompt = "Enter URL: ",
            --default = "http://localhost:8080",
          --}, function(url)
            --if url == nil or url == "" then
              --return
            --else
              --coroutine.resume(co, url)
            --end
          --end)
        --end)
      --end,
      --webRoot = vim.fn.getcwd(),
      --protocol = "inspector",
      --sourceMaps = true,
      --userDataDir = false,
    --},
  }
end

-- automatically toggle the dap-ui on attach 
local dap, dapui = require("dap"), require("dapui")
dap.set_log_level('TRACE')
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- keymaps for dap debugging
vim.keymap.set('n', '<Leader>dj', function() require('dap').step_over() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').step_into() end)
vim.keymap.set('n', '<Leader>dk', function() require('dap').continue() end)
vim.keymap.set('n', '<Leader>dh', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>dc', function() require('dap').run_to_cursor() end)
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>da', function() require('dap').continue({ before = get_args }) end)
vim.keymap.set('n', '<Leader>dq', function() require('dap').disconnect() end)
vim.keymap.set('n', '<Leader>dQ', function() require('dapui').close() end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set('n', '<Leader>dp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

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
