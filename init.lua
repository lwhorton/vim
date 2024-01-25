-- source the old vimscript
--vim.cmd('source ~/.vimrc')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
require('lazy').setup('plugins')

require('options')
require('plugin-configs')
require('autocommands')
require('keybindings')

-- reload (applicable) nvim configs on save
function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = vim.fn.stdpath('config') .. "*.lua",
  callback = function()
    local filepath = vim.fn.expand("%:p")
    local config_dir = vim.fn.stdpath('config') .. '/lua'

    -- check if the saved file is one we can reload
    if filepath:endswith"autocommands.lua"
      or filepath:endswith"keybinds.lua"
      or filepath:endswith"options.lua" then
      dofile(filepath)

      -- reload that particular file
      vim.notify("Configuration reloaded \n" .. filepath, nil)
    end


  end,
  group = mygroup,
  desc = "Reload config on save",
})

