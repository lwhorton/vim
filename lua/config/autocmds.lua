local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- strip trailing whitespace
local function strip_trailing_whitespaces()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.cursor(line, col)
end
vim.api.nvim_create_user_command("StripTrailingWhitespaces", strip_trailing_whitespaces, {})

-- Remove text width limits for CSV files
autocmd("BufReadPre", {
  pattern = "*.csv",
  callback = function()
    vim.opt_local.textwidth = 0
  end,
})

-- enable spellcheck only for markdown and git commits
autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- allow saving files via sudo
vim.api.nvim_create_user_command("W", "write !sudo tee % >/dev/null", { nargs = 0 })

