local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  print("on_attach" .. client.name .. bufnr)

  -- mappings to LSP functions
  -- keymap.set not nvim_set_keymap because we're referencing functions
  vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end, { noremap=true, silent = true, buffer=bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'crrn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'crca', vim.lsp.buf.code_action, bufopts)

  -- clojure specific awesomeness: https://clojure-lsp.io/features/#clojure-lsp-extra-commands
  if client.name == "clojure" then
    vim.keymap.set('n', 'cram', vim.lsp.buf.add_missing_libspec, bufopts)
    vim.keymap.set('n', 'crcn', vim.lsp.buf.clean_ns, bufopts)
    vim.keymap.set('n', 'crdk', vim.lsp.buf.destructure_keys, bufopts)
    vim.keymap.set('n', 'crtf', vim.lsp.buf.thread_first_all, bufopts)
    vim.keymap.set('n', 'crtl', vim.lsp.buf.thread_last_all, bufopts)
    vim.keymap.set('n', 'cruw', vim.lsp.buf.unwind_thread, bufopts)
  end

  -- formatting: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
  -- format the selection
  vim.keymap.set('v', '<Leader>fs', function() 
    vim.lsp.buf.format { 
      -- restrict formatting to the clients attached only to the current buffer
      bufnr = vim.api.nvim_get_current_buf(),
      async = false, -- make it sync for reliability
    }
  end, bufopts)

  -- format the whole file
  vim.keymap.set('n', '<Leader>fa', function() 
    vim.lsp.buf.format { 
      async = false, 
    }
  end, bufopts)

  -- make `=` use lsp formatters, not vim built-ins (for visual mode)
  local function lsp_or_indent_visual()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    -- some lsp servers/languages dont support range formatting, fall back to nvim `=`
    if #clients > 0 then
      vim.lsp.buf.format({
        async = false,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
      })
    else
      vim.cmd("normal! gv=")
    end
  end
  vim.keymap.set("x", "=", lsp_or_indent_visual, bufopts)

  -- align the selected text (EasyAlign) in visual mode
  vim.keymap.set('x', '<Leader>ft', '<Plug>(EasyAlign)', bufopts)
  vim.keymap.set('n', '<Leader>ft', '<Plug>(EasyAlign)', bufopts)
end

-- lsps provide different completion results depending on the capabilities of
-- the client. broadcast to the configured lsps that cmp-nvim has a bunch of
-- capabilities not implemented by native nvim. 
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- activate each LSP
-- each LSP in this list needs to be manually installed via NPM/whatever
local servers = { 
  {
    name = "clojure_lsp",
    cmd = { "clojure-lsp" },
    filetypes = { "clojure", "edn" },
    root_dir = vim.fn.getcwd(),
    settings = {
      trace_level = "messages"
    }
  },
  { name = "jsonls"},
  { name = "eslint"},
}

for _, lsp in pairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  for k, v in pairs(lsp) do
    config[k] = v
  end
  -- for server-specific settings. see `:help lspconfig-setup`
  -- note you cannot send settings as a function to an lsp server! we use this
  -- settings object abstraction to prevent sending any baseline
  -- configurations as functions (like root_dir, filetypes) to the settings
  -- key: https://neovim.discourse.group/t/cannot-serialize-function-type-not-supported/4542/3
  vim.lsp.config(config.name, config)
  vim.lsp.enable(config.name)
end

vim.diagnostic.config({
  virtual_text = {
    prefix = "»",
    virt_text_pos = "eol",
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

return {}
