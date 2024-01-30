-- a place to organize autocmd
--

-- the default floating window colors and other such highlights for coc
-- suggestions / docs are awful for some themes; fix that
--local function my_colors_setup()
  --vim.cmd [[
    --hi CocFloating ctermbg=DarkBlue
    --hi CocHintFloat ctermbg=Green
    --hi CocHintSign ctermbg=Green
    --hi CocHintHighlight ctermbg=Green
    --hi CocHintVirtualText ctermbg=Green
    --hi CocWarningFloat ctermbg=Yellow
    --hi CocWarningSign ctermbg=Yellow
    --hi CocWarningHighlight ctermbg=Yellow
    --hi CocWarningVirtualText ctermbg=Yellow
    --hi CocErrorFloat ctermfg=DarkRed
    --hi CocErrorSign ctermfg=DarkBlue
    --hi CocErrorHighlight ctermfg=DarkRed
    --hi CocErrorVirtualText ctermfg=DarkRed
    --hi FgCocErrorFloatBgCocFloating ctermfg=Red
  --]]
--end
--vim.api.nvim_create_augroup('colorscheme_coc_setup', { clear = true })
--vim.api.nvim_create_autocmd('VimEnter', {
  --group = 'colorscheme_coc_setup',
  --pattern = '*',
  --callback = my_colors_setup
--})

-- remove trailing whitespace, persist cursor position on save
local function strip_trailing_whitespaces()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  vim.cmd('%s/\\s\\+$//e')
  vim.fn.cursor(line, col)
end

vim.api.nvim_create_user_command('StripTrailingWhitespaces', strip_trailing_whitespaces, {})

-- remove text width limits on these filetype
vim.api.nvim_create_autocmd('BufReadPre', {
    pattern = '*.csv',
    callback = function() vim.opt_local.textwidth = 0 end,
})

-- spellcheck readme, git commits
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function() vim.opt_local.spell = true end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    callback = function() vim.opt_local.spell = true end,
})

-- allow saving of files via sudo when I forgot to open the file using sudo
vim.api.nvim_create_user_command('W', 'write !sudo tee % >/dev/null', { nargs = 0 })

-- sort clojure namespaces on file save
local function clj_sort_require_fn(find)
    local initial_line = vim.fn.line(".")
    local initial_col = vim.fn.col(".")
    vim.cmd("keepjumps normal gg")
    vim.cmd("keepjumps /" .. find .. "$")
    local start_line = vim.fn.line(".") + 1

    if start_line ~= 2 then
        vim.cmd("keepjumps normal ^%")
        local end_line = vim.fn.line(".")
        vim.cmd("keepjumps normal i\\<CR>\\<ESC>")
        local closing_line = end_line + 1
        vim.cmd(string.format("%d,%dsort", start_line, end_line))
        vim.cmd("keepjumps normal " .. closing_line .. "gg")
        vim.cmd("keepjumps normal kJ")
    end

    vim.fn.cursor(initial_line, initial_col)
end

vim.api.nvim_create_user_command('CljSortRequire', function(args)
    clj_sort_require_fn(args.args)
end, { nargs = 1 })
