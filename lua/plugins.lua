-- a place for a list of plugins

return {
  -- color schemes
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false, -- make sure we load this during startup (it is the main colorscheme)
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd [[ colorscheme NeoSolarized ]]
    end
  },

  -- https://github.com/knubie/vim-kitty-navigator
  -- make sure to copy the two py files after install: run cp ./*.py ~/.config/kitty/
  {'knubie/vim-kitty-navigator', 
  lazy = false,
  },

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


  -- yank history :YRShow
  { 'vim-scripts/YankRing.vim' },


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
  -- optional deps for telescope
  { 'fannheyward/telescope-coc.nvim'},


  -- syntax-aware select / move / swap / peek for non-lisp shitters
  { 'nvim-treesitter/nvim-treesitter', 
  -- dont forget to run :TSInstall all, then :TSUpdate or :TSUpdate {language parser} after install
  ensure_installed = {
    'bash',
    'clojure',
    'cmake',
    'comment',
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
    vim.cmd [[ TSUpdate]]
  end},
  { 'nvim-treesitter/nvim-treesitter-textobjects' },


  -- snippets
  { 'hrsh7th/vim-vsnip' },
  { 'hrsh7th/vim-vsnip-integ' },

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


  -- lsp-based autocompletion
  -- dont forget to CocInstall coc-json, coc-clojure, coc-tsserver, etc.
  { 'neoclide/coc.nvim', 
  branch = 'release'}, 

  -- Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
  { 'neoclide/coc-tsserver'},

  -- preview markdown files in a browser
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {'guns/vim-clojure-static'},

}


