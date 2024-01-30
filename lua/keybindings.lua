-- a place to organize keybinds

-- escape insert = jf or esc
vim.api.nvim_set_keymap('i', 'jf', '<Esc>', { noremap = false })

-- <leader> is ','
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- <CR> inserts newline without entering insert mode
vim.api.nvim_set_keymap('n', '<CR>', 'o<Esc>', { noremap = false })

-- reselect text block after paste with gV
vim.api.nvim_set_keymap('n', 'gV', [[`[' . getregtype(v:register)[0] . `]']], { noremap = true, expr = true })

-- remap q (macro record) to q because q is now our q-is-window-everything bind
vim.api.nvim_set_keymap('n', 'Q', 'q', { noremap = true })
vim.api.nvim_set_keymap('n', 'q', '<Nop>', { noremap = true })

-- unmap many pain-inducing left hand ctrl{key} sequences

-- unmap qq to prevent recording macros into q, which is confusing 
vim.api.nvim_set_keymap('n', 'qq', '<NOP>', { noremap = true })

-- window page up / down in chunks with our new q-is-window-everything
vim.api.nvim_set_keymap('n', '<C-d>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', 'q8', '<C-d>', { noremap = true })
vim.api.nvim_set_keymap('n', 'q9', '<C-u>', { noremap = true })

-- window splits / moves go to q instead of C-w
vim.api.nvim_set_keymap('n', 'q', '<C-w>', { noremap = true })

-- make redo the opposite of undo 
vim.api.nvim_set_keymap('n', '<C-r>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-U>', '<C-r>', { noremap = true })

-- jump to the symbol matching the one under the cursor
vim.api.nvim_set_keymap('n', ';', '%', { noremap = false })
vim.api.nvim_set_keymap('v', ';', '%', { noremap = false })

-- remap vim-matchup (plugin) to use ; matching (above)
vim.api.nvim_set_keymap('n', '[;', '[%', { noremap = false })
vim.api.nvim_set_keymap('v', '[;', '[%', { noremap = false })
vim.api.nvim_set_keymap('n', '];', ']%', { noremap = false })
vim.api.nvim_set_keymap('v', '];', ']%', { noremap = false })

-- make < > indent changes maintain their selection, if any
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })


-- #order is important here:
-- unmap the ctrl-p/n from yank 
vim.g.yankring_replace_n_pkey = ''
vim.g.yankring_replace_n_nkey = ''
-- unmap <C-p> and <C-n> in normal mode to avoid conflicts
vim.api.nvim_set_keymap('n', '<C-p>', '<NOP>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', '<NOP>', { noremap = true, silent = true })
-- display yankring w/ ctrl-y
vim.api.nvim_set_keymap('n', '<C-y>', ':YRShow<CR>', { noremap = true  })
-- #/order

-- search across file/symbols/buffers/tags with rip-grep, using FZF's syntax and window
vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })

-- highlight words without jumping the cursor randomly
vim.api.nvim_set_keymap('n', '*', '*``', { noremap = true, silent = true })
-- after searching, hit return again (command mode) to clear highlights
vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR><CR>', { noremap = true, silent = true })

-- lsp shortcuts

vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
-- use telescope instead of coc for references search
--vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>Telescope coc references_used<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })

function show_documentation()
  local filetype = vim.bo.filetype
  if filetype == 'vim' or filetype == 'help' then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  else
    if vim.fn.CocAction('hasProvider', 'hover') == 1 then
      vim.fn.CocActionAsync('doHover')
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('K', true, false, true), 'n', true)
    end
  end
end
vim.api.nvim_set_keymap('n', 'K', ':lua show_documentation()<CR>', { noremap = true, silent = true })

-- CoC auto-format
vim.api.nvim_set_keymap('v', '<leader>f', '<Plug>(coc-format-selected)', {})
vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>(coc-format-selected)', {})

-- #clojure lsp magic keybinds
-- auto-import missing clojure libs
vim.api.nvim_set_keymap('n', 'cram', 
    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>", 
    { noremap = true, silent = true })

-- clean clojure namespaces (sort them)
vim.api.nvim_set_keymap('n', 'crcn', 
    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>", 
    { noremap = true, silent = true })

-- move form into let
vim.api.nvim_set_keymap('n', 'crml', 
    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1, vim.fn.input('Binding name: ')}})<CR>", 
    { noremap = true, silent = true })

-- extract form into function 
-- vim.api.nvim_set_keymap('n', 'cref', 
--    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1, vim.fn.input('Function name: ')}})<CR>", 
--    { noremap = true, silent = true })

-- rename symbol under cursor
vim.api.nvim_set_keymap('n', 'crrn', '<Plug>(coc-rename)', { noremap = true, silent = true })

-- auto threaders / unwinders
vim.api.nvim_set_keymap('n', 'crtf', 
    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>", 
    { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'crtl', 
    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>", 
    { noremap = true, silent = true })

-- unwind thread
vim.api.nvim_set_keymap('n', 'cruw', 
    "<cmd>lua vim.fn.CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-thread', 'arguments': {vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>", 
    { noremap = true, silent = true })
-- #/clojure lsp

-- expose autocomplete coc functions as a lua funcs
function coc_tab_complete()
  if vim.fn['coc#pum#visible']() ~= 0 then
    return vim.fn['coc#_select_confirm']()
  else
    return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
  end
end

function coc_pum_next()
  if vim.fn['coc#pum#visible']() ~= 0 then
    return vim.fn['coc#pum#next'](1)
  else
    return vim.api.nvim_replace_termcodes("<C-j>", true, true, true)
  end
end

function coc_pum_prev()
  if vim.fn['coc#pum#visible']() ~= 0 then
    return vim.fn['coc#pum#prev'](1)
  else
    return vim.api.nvim_replace_termcodes("<C-k>", true, true, true)
  end
end
-- coc autocomplete 'Tab = accept auto complete suggestion'
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.coc_tab_complete()', { noremap = true, expr = true, silent = true })
-- coc autocomplete next/prev as ctrl-jk up/down 
vim.api.nvim_set_keymap('i', '<C-j>', "v:lua.coc_pum_next()", {expr = true, noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-k>', "v:lua.coc_pum_prev()", {expr = true, noremap = true, silent = true})
