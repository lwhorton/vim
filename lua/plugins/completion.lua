-- order is important here:
-- 1. get a hook to luasnip
-- 2. configure cmp to use luasnip
-- 3. load snips as needed by filetype per the folder in the config dir
local cmp = require("cmp")
local luasnip = require("luasnip")

-- instead of lazy loading, we're just using a single luasnip.lua file
require("luasnip.loaders.from_snipmate").lazy_load({
  paths = vim.fn.stdpath("config") .. "/lua/snippets",
})

luasnip.setup({
  -- allow jumping back into a snippet, even after you have exited the
  -- template
  history = true,
  -- update dynamic snippets as you type
  updateevents = "TextChanged,TextChangedI",
})

-- Configure nvim-cmp
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  performance = {
    debounce = 60,
    throttle = 30,
    fetching_timeout = 500,
  },
  -- sorting configuration
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,  -- Frequency-based sorting
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-l>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-h>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    -- to change priority of what shows up here, you can reorder these
    -- also, limit when a suggestion window shows up based on key length
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "luasnip", keyword_length = 2 },
    { name = "nvim_lsp_signature_help" },
    { name = "path" },
  },
})

return {}
