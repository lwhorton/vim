return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("kanagawa")
    end,
    overrides = function(colors) -- add/modify highlights
      return {
        ["@punctuation.reader_special"] = { fg = colors.palette.samuraiRed },
      }
    end,
  },
  { "guns/vim-clojure-static", ft = "clojure" },

  -- terminal integration
  { "knubie/vim-kitty-navigator", lazy = false },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    version = "^3.0.0",
    config = function()
      require("kitty-scrollback").setup({
        status_window = {
          enabled = true,
          show_timer = true,
          style_simple = true,
        },
      })
    end,
  },

  -- LSP, with completion
  { 
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load snippets
      require("luasnip.loaders.from_snipmate").lazy_load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })

      luasnip.setup({
        history = true,
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
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
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
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", keyword_length = 2 },
          { name = "luasnip", keyword_length = 2 },
          { name = "nvim_lsp_signature_help" },
          { name = "path" },
        }),
      })
    end,
  },
  { 
    "neovim/nvim-lspconfig",
    dependencies = { 
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- on_attach function
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        print("on_attach: " .. client.name .. " on buffer " .. bufnr)

        -- LSP keymaps
        vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'crrn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', 'crca', vim.lsp.buf.code_action, bufopts)

        -- Clojure-specific commands
        if client.name == "clojure_lsp" then
          vim.keymap.set('n', 'cram', function()
            vim.lsp.buf.execute_command({ command = "add-missing-libspec" })
          end, bufopts)
          vim.keymap.set('n', 'crcn', function()
            vim.lsp.buf.execute_command({ command = "clean-ns" })
          end, bufopts)
        end

        -- Formatting
        vim.keymap.set('v', '<Leader>fs', function() 
          vim.lsp.buf.format { 
            bufnr = vim.api.nvim_get_current_buf(),
            async = false,
          }
        end, bufopts)

        vim.keymap.set('n', '<Leader>fa', function() 
          vim.lsp.buf.format { async = false }
        end, bufopts)

        -- Visual mode formatting with `=`
        vim.keymap.set("x", "=", function()
          vim.lsp.buf.format({
            async = false,
            range = {
              ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
              ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
            },
          })
        end, bufopts)

        -- EasyAlign mappings
        vim.keymap.set('x', '<Leader>ft', '<Plug>(EasyAlign)', bufopts)
        vim.keymap.set('n', '<Leader>ft', '<Plug>(EasyAlign)', bufopts)
      end

      -- Get capabilities from cmp_nvim_lsp
      local capabilities = cmp_nvim_lsp.default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Setup LSP servers using new vim.lsp.config API

      -- Clojure LSP
      vim.lsp.config("clojure_lsp", {
        cmd = { "clojure-lsp" },
        filetypes = { "clojure", "edn" },
        root_markers = { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git", "bb.edn" },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          trace_level = "messages"
        }
      })
      vim.lsp.enable("clojure_lsp")

      -- JSON LSP
      vim.lsp.config("jsonls", {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          provideFormatter = true
        }
      })
      vim.lsp.enable("jsonls")

      -- ESLint
      vim.lsp.config("eslint", {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("eslint")

      -- Diagnostic configuration
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
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
  { "saadparwaiz1/cmp_luasnip" },

  -- clojure REPL
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python" },
    init = function()
      vim.g["conjure#mapping#prefix"] = "c"
      -- for using conjure as the repl, setup some better defaults
      vim.keymap.set("n", "cvt", function()
        vim.cmd("ConjureEval (reverse (deref conjure.internal/tap-queue!))")
      end, { desc = "Peek Conjure tap-queue" })
      vim.g["conjure#client#clojure#nrepl#mapping#view_tap"] = "xt"
      vim.g["conjure#log#hud#anchor"] = "SE"
      vim.g["conjure#log#hud#width"] = 1.0
      vim.g["conjure#log#hud#height"] = 0.2
      vim.g["conjure#log#trim#at"] = 3000
      vim.g["conjure#log#wrap"] = false
      vim.g["conjure#preview#sample_limit"] = 1.0
      vim.g["conjure#extract#tree_sitter#enabled"] = false
      vim.g["conjure#extract#context_header_lines"] = 100
      vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
      vim.g["conjure#client#clojure#nrepl#test#raw_out"] = true
      vim.g["conjure#client#clojure#nrepl#eval#print_options#length"] = 100
      vim.g["conjure#client#clojure#nrepl#eval#print_options#right_margin"] = 128
    end,
  },

  -- git integration
  { 
    "tpope/vim-fugitive",
    init = function()
      vim.cmd("highlight clear SignColumn")
    end
  },
  { "tpope/vim-rhubarb" },

  -- file explorer
  { "tpope/vim-vinegar" },

  { "scrooloose/nerdcommenter" },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function()
      require("telescope").setup({
        defaults = {
          buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
          file_ignore_patterns = {
            "build/",
            ".jpg",
            ".png",
            ".svg",
            ".otf",
            ".ttf",
            "%.class",
            "%.zip",
            ".git/",
            "node_modules/",
            "deps/",
            "client/js/",
            "public/js/",
            "public/dist/",
          },
          path_display = { "smart" },
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              mirror = true,
              height = 0.95,
              width = 0.9,
              prompt_position = "bottom",
              --preview_height = 0.2,
              --preview_width = 0.6,
            }
          }
        },
        pickers = {
          lsp_references = {
            path_display = { "smart" },
          },
          find_files = {
            previewer = require('telescope.previewers').vim_buffer_cat.new({}),
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "clojure", "comment", "lua",
        --"vimdoc", 
        --"javascript", 
        --"typescript" 
        },
        auto_install = false,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enabled = true,
        }
      })
    end,
  },
  {
    "julienvincent/nvim-paredit",
    ft = { "clojure", "fennel", "scheme" }, 
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup(
        {
        cursor_behaviour = "auto", -- or "remain"/"follow" 

        filetypes = { "clojure", "fennel", "scheme" },

        -- disable the magic indent behavior
        indent = {
          enabled = false,
          indentor = require("nvim-paredit.indentation.native").indentor,
        },

        -- default mappings with some vim-sexp-mappings-for-regular-people overrides:
        use_default_keys = true,
        keys = {
          ["<localleader>@"] = { paredit.unwrap.unwrap_form_under_cursor, "Splice sexp" },

          -- vim-surround inspired:
          ["dsf"] = { paredit.unwrap.unwrap_form_under_cursor, "Splice (delete surroundings of form)" },
          ["cse("] = { 
            function()
              paredit.api.wrap_element_under_cursor("(", ")")
            end,
            "Surround element with ()",
            mode = { "n", "v" }
          },
          ["cse)"] = { 
            function()
              paredit.api.wrap_element_under_cursor("(", ")")
            end,
            "Surround element with ()",
            mode = { "n", "v" }
          },
          ["cseb"] = { 
            function()
              paredit.api.wrap_element_under_cursor("(", ")")
            end,
            "Surround element with ()",
            mode = { "n", "v" }
          },

          ["cse["] = { 
            function()
              paredit.api.wrap_element_under_cursor("[", "]")
            end,
            "Surround element with []",
            mode = { "n", "v" }
          },
          ["cse]"] = { 
            function()
              paredit.api.wrap_element_under_cursor("[", "]")
            end,
            "Surround element with []",
            mode = { "n", "v" }
          },

          ["cse{"] = { 
            function()
              paredit.api.wrap_element_under_cursor("{", "}")
            end,
            "Surround element with {}",
            mode = { "n", "v" }
          },
          ["cse}"] = { 
            function()
              paredit.api.wrap_element_under_cursor("{", "}")
            end,
            "Surround element with {}",
            mode = { "n", "v" }
          },

          [">)"] = { paredit.api.slurp_forwards, "Slurp forwards" },
          [">("] = { paredit.api.barf_backwards, "Barf backwards" },

          ["<)"] = { paredit.api.barf_forwards, "Barf forwards" },
          ["<("] = { paredit.api.slurp_backwards, "Slurp backwards" },

          [">e"] = { paredit.api.drag_element_forwards, "Drag element right" },
          ["<e"] = { paredit.api.drag_element_backwards, "Drag element left" },

          [">p"] = { paredit.api.drag_pair_forwards, "Drag element pairs right" },
          ["<p"] = { paredit.api.drag_pair_backwards, "Drag element pairs left" },

          [">f"] = { paredit.api.drag_form_forwards, "Drag form right" },
          ["<f"] = { paredit.api.drag_form_backwards, "Drag form left" },

          ["<localleader>o"] = { paredit.api.raise_form, "Raise form" },
          ["<localleader>O"] = { paredit.api.raise_element, "Raise element" },

          ["E"] = {
            paredit.api.move_to_next_element_tail,
            "Jump to next element tail",
            -- by default all keybindings are dot repeatable
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },
          ["W"] = {
            paredit.api.move_to_next_element_head,
            "Jump to next element head",
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },

          ["B"] = {
            paredit.api.move_to_prev_element_head,
            "Jump to previous element head",
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },
          ["gE"] = {
            paredit.api.move_to_prev_element_tail,
            "Jump to previous element tail",
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },

          ["("] = {
            paredit.api.move_to_parent_form_start,
            "Jump to parent form's head",
            repeatable = false,
            mode = { "n", "x", "v" },
          },
          [")"] = {
            paredit.api.move_to_parent_form_end,
            "Jump to parent form's tail",
            repeatable = false,
            mode = { "n", "x", "v" },
          },
          ["]]"] = {
            paredit.api.move_to_next_element_tail,
            "Jump to next element tail",
            repeatable = false,
            mode = { "n", "x", "v" },
          },
          ["[["] = {
            paredit.api.move_to_top_level_form_head,
            "Jump to next top level form",
            repeatable = false,
            mode = { "n", "x", "v" },
          },

          -- These are text object selection keybindings which can used with standard `d, y, c`, `v`
          ["af"] = {
            paredit.api.select_around_form,
            "Around form",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["if"] = {
            paredit.api.select_in_form,
            "In form",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["aF"] = {
            paredit.api.select_around_top_level_form,
            "Around top level form",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["iF"] = {
            paredit.api.select_in_top_level_form,
            "In top level form",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["ae"] = {
            paredit.api.select_element,
            "Around element",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["ie"] = {
            paredit.api.select_element,
            "Element",
            repeatable = false,
            mode = { "o", "v" },
          },
        },
      }
    )
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    options = {
      theme = "onenord",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },

  -- auto-pairs
  { 
    "cohama/lexima.vim", 
    config = function()
      -- disable auto-closing quotes
      vim.fn["lexima#add_rule"]({ char = '"', input_after = "" })
      vim.fn["lexima#add_rule"]({ char = '""', input_after = "" })
      vim.fn["lexima#add_rule"]({ char = "'", input_after = "" })
      vim.fn["lexima#add_rule"]({ char = "''", input_after = "" })
      vim.fn["lexima#add_rule"]({ char = "``", input_after = "" })
    end
  },

  -- better matching
  { 
    "andymass/vim-matchup", 
    init = function()
      vim.g.matchup_delim_stopline = 2000
      vim.g.matchup_matchparen_stopline = 400
      vim.g.matchup_treesitter_stopline = 400
    end
  },
  { "editorconfig/editorconfig-vim" },

  -- utilities
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "yssl/QFEnter", 
  init = function()
    vim.g.qfenter_keymap = {
      open = { "<CR>" },
      hopen = { "<leader>j" },
      vopen = { "<leader>k" },
    }
  end},
  { "junegunn/vim-easy-align" },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  -- performance optimization
  {
    "pteroctopus/faster.nvim",
    enabled = true,
    opts = {
      behaviours = {
        bigfile = {
          on = true,
          features_disabled = {
            "matchparen",
            "lsp",
            "treesitter",
            "vimopts",
            "syntax",
            "filetype",
          },
          filesize = 100,
          pattern = "*",
          extra_patterns = {},
        },
        fastmacro = {
          on = true,
          features_disabled = { "lualine" },
        },
      },
    },
  },
}

