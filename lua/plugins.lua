-- a place for a list of plugins

return {
  -- color schemes
  --{ 'rktjmp/lush.nvim' },

    --{
    --"Tsuzat/NeoSolarized.nvim",
    --lazy = false, -- make sure we load this during startup (it is the main colorscheme)
    --priority = 1000, -- make sure to load this before all the other start plugins
  --},
  --
  --
  --{'morhetz/gruvbox', 
  --lazy = false,
  --priority = 1000,
  --config = function() 
    --vim.cmd.colorscheme('gruvbox') 
    --vim.cmd('set background=dark') 
    ---- https://github.com/morhetz/gruvbox/wiki/Configuration#ggruvbox_contrast_dark
    ---- soft/medium(default)/hard
    --vim.g.gruvbox_contrast_dark = 'medium'
  --end 
  --},

  --{'p00f/alabaster.nvim', -- this port relies on treesitter instead of lsp :(
  --lazy = false,
  --priority = 1000,
  --config = function() 
    --vim.opt.termguicolors = true
    --vim.cmd.colorscheme('alabaster') 
    --vim.cmd('set background=dark') 
    ---- https://github.com/p00f/alabaster.nvim
  --end 
  --},
  --{
    --dir = '/Users/luke/.config/nvim/nvim_colors', 
    --lazy = false,
    --priority = 1000,
    --config = function() 
      --vim.cmd.colorscheme("alabaster_dark")
    --end 
  --},
  {'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      --vim.cmd.colorscheme('kanagawa')
    end
  },
  {'zenbones-theme/zenbones.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenbones_compat = 1
    end
  },
  {'ishan9299/nvim-solarized-lua',
    lazy = false,
    priority = 1000,
    config = function()
      --vim.cmd.colorscheme('solarized')
    end
  },
  {'rmehri01/onenord.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('onenord')
    end
  },

  -- https://github.com/knubie/vim-kitty-navigator
  -- make sure to copy the two py files after install: run cp ./*.py ~/.config/kitty/
  {'knubie/vim-kitty-navigator', lazy = false, },

  -- setup native LSP with a completion engine
  { 'neovim/nvim-lspconfig' },
  -- 
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-nvim-lsp-signature-help'},
  {'hrsh7th/cmp-path'},
  -- we dont need exactly LuaSnip for nvim-cmp, but we need at least some snippet engine
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  -- luasnip needs a completion source
  { 'saadparwaiz1/cmp_luasnip' },

  -- repl! https://github.com/Olical/conjure/wiki/Quick-start:-Clojure
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python" }, -- etc
    lazy = true,
    init = function()
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- vim.g["conjure#debug"] = true

      -- keybind overrides MUST BE SET HERE, not elsewhere, due to the loading
      -- order: bindings defined elsewhere are set then overridden during lazy
      -- load!

      -- conjure repl mappings to be more like vim fireplace (instead of <leader>, use 'c')
      vim.g['conjure#mapping#prefix'] = 'c'
      -- rebind to 'eXpunge tap' and 'view tap' (dont clear the queue)
      vim.g["conjure#client#clojure#nrepl#mapping#view_tap"] = "xt"
      vim.keymap.set("n", tostring(vim.g['conjure#mapping#prefix']) .. "vt", function()
        vim.cmd("ConjureEval (reverse (deref conjure.internal/tap-queue!))")
      end, { desc = "Peek Conjure tap-queue" })
    end,

    -- Optional cmp-conjure integration (currently using cmp-nvim-lsp)
    --dependencies = { "PaterJason/cmp-conjure" },
  },

  -- git integration
  {  'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },

  -- press '-' to get a project drawer / tree
  { 'tpope/vim-vinegar' },

  -- yank history :Yanks
  --{ 'maxbrunsfeld/vim-yankstack' },

  -- toggling comments for line(s) <leader>c<space>
  {'scrooloose/nerdcommenter'},

  -- db integration
  --{ 'vim-scripts/dbext.vim' }

  -- file/grep/buffer searching
  -- also requires ripgrep on the system
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- syntax-aware select / move / swap / peek for non-lisp shitters
  { 'nvim-treesitter/nvim-treesitter', 
  -- dont forget to run :TSInstall all, then :TSUpdate or :TSUpdate {language parser} after install
  ensure_installed = {
    'bash',
    'cmake',
    'comment',
    'clojure',
    'css',
    'dockerfile',
    'elixir',
    'erlang',
    'gitignore',
    'go',
    'graphql',
    'html',
    'java',
    'javascript',
    'json',
    'json5',
    'lua', 
    'make',
    'query', 
    'regex',
    'typescript', 
    'vim', 
    'yaml', 
  },
    lazy = false,
    build = ':TSUpdate',
    auto_install = true,
    -- also configured further in plugin-configs
  },

  -- status bar on the bottom
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    options = { theme = 'auto' },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'},
    },
  },

  -- auto insert matching \{ \[ \( etc.
  { 'cohama/lexima.vim' },

  -- vim motion to match to language constructs like [, {, if/do blocks 
  { 'andymass/vim-matchup' },

  -- editorconfig.org for vim
  {  'editorconfig/editorconfig-vim' },

  -- better mapping for slurp/barf/slice/split s-expression structural editing 
  {  'guns/vim-sexp' },
  {  'tpope/vim-sexp-mappings-for-regular-people' },

  -- so plugins can tap into "." repeat functionality
  { 'tpope/vim-repeat' },

  -- add/remove surrounding things: \( \" \:, etc. via cs{w/e/character}{replacement-character}
  { 'tpope/vim-surround'},

  -- enable opening windows directly from quickfix menu (i, enter, etc.)
  { 'yssl/QFEnter' },

  -- easy alignment for tabular/whitespace-driven text alignment
  { 'junegunn/vim-easy-align' },

  -- preview markdown files in a browser
    -- avoid node 
  --{
    --'iamcco/markdown-preview.nvim',
    --cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    --ft = { 'markdown' },
    --build = function() vim.fn["mkdp#util#install"]() end,
  --},

    -- use node
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    version = '^3.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('kitty-scrollback').setup()
    end,
  },

  -- debugger
  {"mfussenegger/nvim-dap"},
  {
    'microsoft/vscode-js-debug',
    build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'
  },
--  {'mxsdev/nvim-dap-vscode-js',
--    dependencies = {'mfussenegger/nvim-dap', 'microsoft/vscode-js-debug'},
--  },
--  { "rcarriga/nvim-dap-ui", 
--    dependencies = {"mfussenegger/nvim-dap"},
--    config = function()
--      -- this has to happen before anything else in dapui
--      require('dapui').setup()
--    end
--  },

  -- https://github.com/pteroctopus/faster.nvim
  {"pteroctopus/faster.nvim", 
    enabled = true,
    opts = {
      -- Behaviour table contains configuration for behaviours faster.nvim uses
      behaviours = {
        -- Bigfile configuration controls disabling and enabling of features when
        -- big file is opened 
        bigfile = {
          -- Behaviour can be turned on or off. To turn on set to true, otherwise
          -- set to false
          on = true,
          -- Table which contains names of features that will be disabled when
          -- bigfile is opened. Feature names can be seen in features table below.
          -- features_disabled can also be set to "all" and then all features that
          -- are on (on=true) are going to be disabled for this behaviour
          features_disabled = {
            "matchparen", "lsp", "treesitter",
            "vimopts", "syntax", "filetype"
          },
          -- Files larger than `filesize` are considered big files. Value is in MB.
          filesize = 1,
          -- Autocmd pattern that controls on which files behaviour will be applied.
          -- `*` means any file.
          pattern = "*",
          -- Optional extra patterns and sizes for which bigfile behaviour will apply.
          -- Note! that when multiple patterns (including the main one) and filesizes
          -- are defined: bigfile behaviour will be applied for minimum filesize of
          -- those defined in all applicable patterns for that file.
          -- extra_pattern example in multi line comment is bellow:
          --[[
      extra_patterns = {
        -- If this is used than bigfile behaviour for *.md files will be
        -- triggered for filesize of 1.1MiB
        { filesize = 1.1, pattern = "*.md" },
        -- If this is used than bigfile behaviour for *.log file will be
        -- triggered for the value in `behaviours.bigfile.filesize`
        { pattern  = "*.log" },
        -- Next line is invalid without the pattern and will be ignored
        { filesize = 3 },
      },
      ]]
          -- By default `extra_patterns` is an empty table: {}.
          extra_patterns = {},
        },
        -- Fast macro configuration controls disabling and enabling features when
        -- macro is executed
        fastmacro = {
          -- Behaviour can be turned on or off. To turn on set to true, otherwise
          -- set to false
          on = true,
          -- Table which contains names of features that will be disabled when
          -- macro is executed. Feature names can be seen in features table below.
          -- features_disabled can also be set to "all" and then all features that
          -- are on (on=true) are going to be disabled for this behaviour.
          -- Specificaly: lualine plugin is disabled when macros are executed because
          -- if a recursive macro opens a buffer on every iteration this error will
          -- happen after 300-400 hundred iterations:
          -- `E5108: Error executing lua Vim:E903: Process failed to start: too many open files: "/usr/bin/git"`
          features_disabled = { "lualine" },
        }
      },
      -- Feature table contains configuration for features faster.nvim will disable
      -- and enable according to rules defined in behaviours.
      -- Defined feature will be used by faster.nvim only if it is on (`on=true`).
      -- Defer will be used if some features need to be disabled after others.
      -- defer=false features will be disabled first and defer=true features last.
      features = {
        -- Neovim filetype plugin
        -- https://neovim.io/doc/user/filetype.html
        filetype = {
          on = true,
          defer = true,
        },
        -- Neovim LSP
        -- https://neovim.io/doc/user/lsp.html
        lsp = {
          on = true,
          defer = false,
        },
        -- Lualine
        -- https://github.com/nvim-lualine/lualine.nvim
        lualine = {
          on = true,
          defer = false,
        },
        -- Neovim Pi_paren plugin
        -- https://neovim.io/doc/user/pi_paren.html
        matchparen = {
          on = true,
          defer = false,
        },
        -- Neovim syntax
        -- https://neovim.io/doc/user/syntax.html
        syntax = {
          on = true,
          defer = true,
        },
        -- Neovim treesitter
        -- https://neovim.io/doc/user/treesitter.html
        treesitter = {
          on = true,
          defer = false,
        },
        -- Neovim options that affect speed when big file is opened:
        -- swapfile, foldmethod, undolevels, undoreload, list
        vimopts = {
          on = true,
          defer = false,
        }
      }
    }
  }
}


