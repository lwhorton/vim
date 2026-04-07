local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- these have to be set before loading lazy
vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.o.verbose = 9
vim.o.verbosefile = '/tmp/nvim_session_' .. os.date('%Y%m%d_%H%M%S') .. '.log'

-- load core configs
require("config.options")
require("config.keymaps")
require("config.autocmds")

require('lazy').setup('plugins', {
  change_detection = {
    notify = false
  }
})
