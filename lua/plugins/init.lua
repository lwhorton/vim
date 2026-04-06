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
  --{
    --"uhs-robert/oasis.nvim",
    --lazy = false,
    --priority = 1000,
    --config = function()
      ---- https://github.com/uhs-robert/oasis.nvim
      --require("oasis").setup()  
      --vim.opt.termguicolors = true
      --vim.cmd.colorscheme("oasis-night") -- after setup
    --end
  --},
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
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-path" },
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
      vim.g["conjure#client#clojure#nrepl#mapping#view_tap"] = "xt"
      vim.keymap.set("n", "cvt", function()
        vim.cmd("ConjureEval (reverse (deref conjure.internal/tap-queue!))")
      end, { desc = "Peek Conjure tap-queue" })
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
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" }, -- forces lazy-load; known issue where ensure_installed doesnt work due to race condition
    lazy = true,
    build = ":TSUpdate",
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
  { "cohama/lexima.vim", config = function()
    -- disable auto-closing quotes
    vim.fn["lexima#add_rule"]({ char = '"', input_after = "" })
    vim.fn["lexima#add_rule"]({ char = '""', input_after = "" })
    vim.fn["lexima#add_rule"]({ char = "'", input_after = "" })
    vim.fn["lexima#add_rule"]({ char = "''", input_after = "" })
    vim.fn["lexima#add_rule"]({ char = "``", input_after = "" })
  end
  },

  -- better matching
  { "andymass/vim-matchup", 
    init = function()
      vim.g.matchup_delim_stopline = 25000
      vim.g.matchup_matchparen_stopline = 400
    end},

  { "editorconfig/editorconfig-vim" },

  -- s-expression editing
  { 
    "guns/vim-sexp",
    ft = { 'clojure' },
    config = function()
      vim.g.sexp_enable_insert_mode_mappings = 0
      -- disable this new "feature" smart paste 
      vim.g.sexp_mappings = {
        sexp_put_before = '',
        sexp_put_after = '',
        sexp_replace = '',
        sexp_replace_P = '',
      }
    end
  },
  { "tpope/vim-sexp-mappings-for-regular-people" },

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
          filesize = 1,
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

