local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- escape insert = jf or esc
keymap('i', 'jf', '<Esc>', { noremap = false })

-- insert newline without entering insert mode
keymap("n", "<CR>", "o<Esc>", { noremap = false })

-- reselect text block after paste with gV
keymap("n", "gV", [[`[' . getregtype(v:register)[0] . `]']], { noremap = true, expr = true })

-- remap macro recording: Q for record, disable default q
keymap("n", "Q", "q", opts)
keymap("n", "q", "<Nop>", opts)
-- unmap qq to prevent recording macros INTO q, which is confusing
keymap("n", "qq", "<Nop>", opts)

-- unmap many pain-inducing left hand ctrl{key} sequences

-- window splits / moves go to q (instead of C-w)
keymap("n", "q", "<C-w>", opts)

-- page up/down with q8/q9 (disable C-d/C-u)
keymap("n", "<C-d>", "<Nop>", opts)
keymap("n", "<C-u>", "<Nop>", opts)
keymap("n", "q8", "<C-d>", opts)
keymap("n", "q9", "<C-u>", opts)

-- make redo the opposite of undo 
keymap("n", "<C-r>", "<Nop>", opts)
keymap("n", "<S-U>", "<C-r>", opts)

-- jump to the symbol matching under cursor
keymap("n", ";", "%", { noremap = false })
keymap("v", ";", "%", { noremap = false })
-- remap vim-matchup (plugin) to use ; matching above
keymap("n", "[;", "[%", { noremap = false })
keymap("v", "[;", "[%", { noremap = false })
keymap("n", "];", "]%", { noremap = false })
keymap("v", "];", "]%", { noremap = false })

-- make < > indent changes maintain their selection, if any
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- allow tab navation in insert mode
keymap("n", "<S-Tab>", "<<", opts)
keymap("i", "<S-Tab>", "<C-d>", opts)

-- telescope
keymap("n", "<C-s>", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<C-d>", "<cmd>Telescope grep_string<CR>", opts)
keymap("n", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<C-r>", "<cmd>Telescope resume<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

keymap("n", "*", function()
  vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
  vim.opt.hlsearch = true
end, { desc = "Search for whole word under cursor, without moving." })

-- search for partial match under cursor (like `g*`), but don't move cursor
keymap("n", "g*", function()
  vim.fn.setreg("/", vim.fn.expand("<cword>"))
  vim.opt.hlsearch = true
end, { desc = "Search for partial word under cursor, without moving." })

-- after searching, hit return again (command mode) to clear highlights
keymap("n", "<CR>", ":noh<CR><CR>", opts)
