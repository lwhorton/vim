-- a place for a list of plugins

return {
  -- color schemes
  --{
    --"Tsuzat/NeoSolarized.nvim",
    --lazy = false, -- make sure we load this during startup (it is the main colorscheme)
    --priority = 1000, -- make sure to load this before all the other start plugins
  --},

  {'morhetz/gruvbox', 
  lazy = false,
  priority = 1000,
  config = function() 
    vim.cmd.colorscheme('gruvbox') 
    vim.cmd('set background=dark') 
    -- https://github.com/morhetz/gruvbox/wiki/Configuration#ggruvbox_contrast_dark
    -- soft/medium(default)/hard
    vim.g.gruvbox_contrast_dark = 'medium'
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

  -- repl with auto-connect, :Console :FireplaceConnect 
  { 'tpope/vim-fireplace' },
  { 'tpope/vim-salve'},

  -- file status bar
  {'vim-airline/vim-airline' },
  {'vim-airline/vim-airline-themes' },


  -- count the search results
  { 'google/vim-searchindex' },

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
  auto_install = true,
  config = function()
    vim.cmd [[ TSUpdate ]]
  end},

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


  -- preview markdown files in a browser
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn["mkdp#util#install"]() end,
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
  {'mxsdev/nvim-dap-vscode-js',
    dependencies = {'mfussenegger/nvim-dap', 'microsoft/vscode-js-debug'},
  },
  { "rcarriga/nvim-dap-ui", 
    dependencies = {"mfussenegger/nvim-dap"},
    config = function()
      -- this has to happen before anything else in dapui
      require('dapui').setup()
    end
  },
}


