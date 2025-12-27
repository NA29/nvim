vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.g.markdown_recommended_style = 0
vim.opt.cursorline = true
vim.opt.scrolloff = 8
-- vim.opt.scrolljump = 1
-- vim.opt.virtualedit = "onemore"
vim.opt.smoothscroll = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = " "


-- =========================
-- lazy.nvim bootstrap
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Diagnostics UI
-- =========================
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
  severity_sort = true,
})

vim.keymap.set(
  "n",
  "ge",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic under cursor" }
)

-- Moving lines up and down with Alt
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

-- =========================
-- Plugins
-- =========================
local plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>f", builtin.live_grep, {})
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end
      configs.setup({
        ensure_installed = { "lua", "javascript", "cpp", "python", "markdown", "markdown_inline", "nix"},
        sync_install = false,
        auto_install = true,
        highlight = { enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
},

{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({})
  end,
},

{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>")
    vim.keymap.set(
      "n",
      "<C-m>",
      ":Neotree filesystem focus left<CR>",
      { desc = "Focus Neo-tree" }
    )
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>")
    require("neo-tree").setup({
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = false,

        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },

        window = {
          mappings = {
            -- smart open
            ["l"] = "open",
            ["<CR>"] = "open",

            -- re-root explicitly
            ["R"] = "set_root",

            -- navigation
            ["h"] = "navigate_up",
            ["<BS>"] = "navigate_up",

            -- toggles
            ["H"] = "toggle_hidden",
            ["I"] = "toggle_gitignored",
          },
        },
      },
    })


  end,
},

{
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "SmiteshP/nvim-navic", -- breadcrumb backend
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "clangd",
        "marksman",
      },
    })

    local cmp = require("cmp")
    local navic = require("nvim-navic")
    local luasnip = require("luasnip")

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback() -- inserts spaces (expandtab)
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      sources = {
        { name = "luasnip"},
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local on_attach = function(_, bufnr)
      local opts = { buffer = bufnr, silent = true }
      -- navigation
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

      vim.keymap.set(
        "n",
        "gD",
        function ()
          vim.cmd("vsplit")
          vim.lsp.buf.definition()
        end, { buffer = bufnr, silent = true, desc = "Definition in vertical split" })

      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

      vim.keymap.set(
        "n",
        "gI",
        function ()
          vim.cmd("vsplit")
          vim.lsp.buf.implementation()
        end, { buffer = bufnr, silent = true, desc = "Implementation in vertical split" })

      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)

      -- info
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config("pyright", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config("clangd", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config("marksman", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
},

{
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
      },
    })
  end,
},

-- =========================
-- Breadcrumbs (winbar)
-- =========================
{
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("barbecue").setup({
      show_dirname = true,
      show_basename = true,
      show_modified = true,
      symbols = {
        separator = " › ",
      },
    })
  end,
},

{
  "rainbowhxch/accelerated-jk.nvim",
  config = function()
    require("accelerated-jk").setup()
  end,
},
{
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    code = {
      enabled = true,
      -- highlight = true,
      style = 'normal',
      border = 'thin',
      conceal_delimiters = false,
      language = true,
      language_icon = true,
      language_name = true,
      width = 'full',
    },
  },
},
  {
    "rubiin/fortune.nvim",
    config = function()
      require("fortune").setup()
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
        dashboard.button("h", "󰋚  Recently opened files", ":Telescope oldfiles<CR>"),
        dashboard.button("r", "󰑕  Frecency / MRU", ":Telescope frecency<CR>"),
        dashboard.button("g", "󰊄  Find word", ":Telescope live_grep<CR>"),
        dashboard.button("m", "󰃀  Jump to bookmarks", ":Telescope marks<CR>"),
        dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
      }

      dashboard.section.footer.val = require("fortune").get_fortune()

      alpha.setup(dashboard.config)
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets("markdown", {
        -- Notes
        s("note", { t("> **Note:** "), i(1) }),
        s("tip",  { t("> **Tip:** "), i(1) }),
        s("warn", { t("> **Warning:** "), i(1) }),
        s("info", { t("> **Info:** "), i(1) }),
        s("def", {
          t("**"),
          i(1, "Term"),
          t("** — "),
          i(2, "definition"),
        });
        -- Formatting
        s("bold",   { t("**"), i(1), t("**") }),
        s("italic", { t("*"),  i(1), t("*") }),
        s("code",   { t("`"),  i(1), t("`") }),
        s("strike", { t("~~"), i(1), t("~~") }),
        -- Links / media
        s("link", { t("["), i(1), t("]("), i(2), t(")") }),
        s("img",  { t("!["), i(1), t("]("), i(2), t(")") }),
        -- Code blocks
        s("cb", {
          t("```"), i(1, "language"),
          t({ "", "" }),
          i(2),
          t({ "", "```" }),
        }),
        -- Lists
        s("ul",   { t("- "), i(1) }),
        s("ol",   { t("1. "), i(1) }),
        s("task", { t("- [ ] "), i(1) }),
        -- Headings
        s("h1", { t("# "), i(1) }),
        s("h2", { t("## "), i(1) }),
        s("h3", { t("### "), i(1) }),
        s("h4", { t("#### "), i(1) }),
        s("h5", { t("##### "), i(1) }),
        s("h6", { t("###### "), i(1) }),
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    opts = {},
    config = function ()
      require('scrollEOF').setup()
    end
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      local neoscroll = require("neoscroll")
      neoscroll.setup({
        easing_function = "quadratic",
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = true,
        cursor_scrolls_alone = true,
      })

      local keymap = vim.keymap.set
      local scroll = neoscroll.scroll

      keymap("n", "<C-d>", function()
        scroll(vim.wo.scroll, { duration = 120 })
      end, { silent = true })

      keymap("n", "<C-u>", function()
        scroll(-vim.wo.scroll, { duration = 120 })
      end, { silent = true })

      keymap("n", "<C-f>", function()
        scroll(vim.api.nvim_win_get_height(0), { duration = 200 })
      end, { silent = true })

      keymap("n", "<C-b>", function()
        scroll(-vim.api.nvim_win_get_height(0), { duration = 200 })
      end, { silent = true })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufReadPost",
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "markdown_inline" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  }
,
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end,
        desc = "Open mini.files (cwd)",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 50,
      },
    },
  }
}

require("lazy").setup(plugins, {})
