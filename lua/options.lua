-- a place for all the nvim options

vim.cmd('set nocompatible')
vim.opt.updatetime = 750

-- limit syntax highlighting width, otherwise the world stops
vim.o.synmaxcol = 300

-- setup not-stupid tab defaults
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', { noremap = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', '<C-d>', { noremap = true })

-- prevent leaving splits off in buffer land to be lost forever
vim.opt.autowriteall = true
vim.opt.confirm = true

-- don't beep, do visual bell
vim.opt.visualbell = true

-- no swap files
--vim.opt.directory=~/.vim/swap = 
vim.cmd('set noswapfile')

-- no wrapping/auto-inserting of \n
vim.cmd('set nowrap')
vim.opt.textwidth = 80 

-- allow deleting text inserted before current insert mode started
vim.opt.backspace = 'indent,eol,start'

-- enable vim solarized color scheme 
vim.cmd('syntax enable')
vim.cmd('colorscheme NeoSolarized')
vim.opt.termguicolors = true
vim.opt.background = 'light'
--vim.opt.background = 'dark'

-- limit syntax highlighting otherwise the world stops
vim.opt.synmaxcol = 256

-- vim.opt =up not-stupid tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- smart case sensitivity while searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- highlight /search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- persist undo to file
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('config') .. '/undo'

-- hybrid line numbers
--vim.opt.rnu -- ? vim cannot handle relative line numbers on files > 100 lines, too slow = 
vim.opt.nu = true

-- turn off all character hiding (like hiding of --: in json/markdown files)
vim.opt.conceallevel = 0

-- optional, configure as-you-type completions
vim.cmd('set completeopt=menu,menuone,preview,noselect,noinsert')

-- the default matching cursor color is bad, so fix it
-- https://stackoverflow.com/questions/10746750/set-vim-bracket-highlighting-colors
vim.api.nvim_set_hl(0, 'MatchParen', { 
  bold = true, 
  standout = false,
  underdouble = true,
  fg = 'Black', 
  bg = 'none' })

