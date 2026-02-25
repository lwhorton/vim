-- for using conjure as the repl, setup some better defaults
vim.g["conjure#log#hud#anchor"] = "SE"
vim.g["conjure#log#hud#width"] = 1.0
vim.g["conjure#log#hud#height"] = 0.2
vim.g["conjure#log#trim#at"] = 3000
vim.g["conjure#log#wrap"] = false
vim.g["conjure#extract#tree_sitter#enabled"] = false
vim.g["conjure#extract#context_header_lines"] = 100
vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
vim.g["conjure#client#clojure#nrepl#test#raw_out"] = true
vim.g["conjure#client#clojure#nrepl#eval#print_options#length"] = 100
vim.g["conjure#client#clojure#nrepl#eval#print_options#right_margin"] = 128

-- kill evaluating clojure via conjure
--TODO vim.keymap.set('n', 'ckk', vim.lsp.buf.code_action, bufopts)

return {}
