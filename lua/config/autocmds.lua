local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- enable treesitter
autocmd('FileType', {
  pattern = { 'clojure' },
  callback = function()
    vim.treesitter.start()
  end,
})

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

-- for lisp files, make paredit mappings take precedence over nvim-surround
--autocmd("FileType", {
  --pattern = { "clojure", "fennel", "scheme", "lisp", "racket" },
  --callback = function(event)
    --local paredit = require("nvim-paredit")
    --vim.keymap.set('n', 'dsf', paredit.api.unwrap_form_under_cursor, 
      --{ buffer = event.buf, desc = "Paredit: Splice form" })
    
    --vim.keymap.set('n', 'cse(', function() 
      --paredit.api.wrap_element_under_cursor("(", ")") 
    --end, { buffer = event.buf, desc = "Paredit: Wrap with ()" })
    
    --vim.keymap.set('n', 'cse[', function() 
      --paredit.api.wrap_element_under_cursor("[", "]") 
    --end, { buffer = event.buf, desc = "Paredit: Wrap with []" })
    
    --vim.keymap.set('n', 'cse{', function() 
      --paredit.api.wrap_element_under_cursor("{", "}") 
    --end, { buffer = event.buf, desc = "Paredit: Wrap with {}" })
  --end,
--})

-- allow saving files via sudo
vim.api.nvim_create_user_command("W", "write !sudo tee % >/dev/null", { nargs = 0 })

-- conjure: prefix logs with timestamp and the full expression
--local function add_timestamp_to_conjure_log()
  --local eval_info = vim.g.last_conjure_eval
  --print("log called with:", vim.inspect(eval_info))
  --print("log called with:", vim.g.last_conjure_eval)
  --if not eval_info then return end

  ---- find conjure-log buffer
  --for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    --local bufname = vim.fn.bufname(bufnr)
    --if bufname:match("conjure%-log%-") then
      ---- Get the last few lines of the log buffer
      --local lookback = 10
      --local line_count = vim.api.nvim_buf_line_count(bufnr)
      --local start_line = math.max(0, line_count - lookback)
      --local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, line_count, false)
      
      --for i = #lines, 1, -1 do
        --local is_eval_header = lines[i]:match("^; eval %(")
        --local has_timestamp = lines[i]:match("^; %[%d%d%d%d%-%d%d%-%d%d")
        
        --if is_eval_header and not has_timestamp then
          --local timestamp = "[" .. eval_info.timestamp .. "]"
          --local origin = eval_info.origin or "unknown"

          ---- New header line
          --local header = "; " .. timestamp .. " eval (" .. origin .. ")"
          
          ---- Full form, not commented
          --local full_form = eval_info.code

          ---- Replace "; eval" with "; [timestamp] eval\n full_form"
          --local line_num = start_line + i - 1
          --vim.api.nvim_buf_set_lines(bufnr, line_num, line_num + 1, false, { header, full_form })
          --break
        --end
      --end
    --end
  --end
--end

--autocmd("User", {
  --pattern = "ConjureEval",
  --callback = add_timestamp_to_conjure_log,
--})
