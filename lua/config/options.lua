-- # General
vim.opt.compatible = false
vim.opt.syntax = "enable"
vim.opt.updatetime = 400
-- always show the signcolumn, otherwise completions would shift the text
vim.opt.signcolumn = "yes"
-- limit syntax highlighting width, for performance
vim.opt.synmaxcol = 300

-- # Tab
-- setup not-stupid tab defaults
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- # Buffer
-- prevent leaving splits off in buffer land to be lost forever
vim.opt.autowriteall = true
vim.opt.confirm = true
vim.opt.swapfile = false

-- # UI 
-- don't beep, do visual bell
vim.opt.visualbell = true
vim.opt.wrap = false
-- turn off all character hiding (like hiding of --: in json/markdown files)
vim.opt.conceallevel = 0
-- hybrid line numbers
vim.opt.number = true

-- # Text Formatting
-- dont auto-wrap exceeding textwidth
-- c auto-wrap comments using textwidth, 
-- r auto-insert comment leader on <return> (in insert mode)
-- o auto-insert comment leader on o, O (in normal mode)
-- q allow gq to manually re-flow comments
-- l dont break long lines already containing line breaks (respect existing structure)
vim.opt.textwidth = 0
vim.opt.formatoptions:remove("t")
vim.opt.formatoptions:remove("o")
vim.opt.formatoptions:append("c")
vim.opt.formatoptions:append("r")
vim.opt.formatoptions:append("q")
vim.opt.formatoptions:append("l")
vim.opt.backspace = "indent,eol,start"

-- # Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = false

-- # Undo 
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"

-- # Completion
-- configure as-you-type completions
vim.opt.completeopt = "menu,menuone,preview,noselect,noinsert"

-- # Syntax Highlight
-- the default matching cursor color is bad (for some themes): so fix it
--vim.api.nvim_set_hl(0, "MatchParen", {
  --bold = true,
  --standout = false,
  --underdouble = true,
  --bg = "none",
--})
