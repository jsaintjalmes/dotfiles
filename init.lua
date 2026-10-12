-- ============================================================================
-- 1. LEADER KEY SETUP
-- Must be set before lazy.nvim plugin manager loads
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- 2. PLUGIN MANAGEMENT (lazy.nvim)
-- ============================================================================
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

require("lazy").setup({
  -- Modern Lua File Explorer (Pure Text / ASCII mode)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        actions = {
          open_file = {
            window_picker = {
              enable = false, -- open file in last focused window
            },
          },
        },
        renderer = {
          group_empty = true,
          icons = {
            webdev_colors = false,
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = false,
              modified = false,
              hidden = false,
              diagnostics = false,
              bookmarks = false,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },

  -- Telescope (Fuzzy Finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })
    end,
  },

  -- Editing Utilities
  "preservim/nerdcommenter",
  "rhysd/vim-clang-format",
  "ntpeters/vim-better-whitespace",
  "rust-lang/rust.vim",

  -- Native Neovim LSP Configurations & Autocompletion
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",      -- Autocompletion engine
  "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp

  -- Colorscheme
  {
    'clearaspect/onehalf',
    lazy = false,
    priority = 1000,
  },
})

-- ============================================================================
-- 3. GENERAL OPTIONS
-- ============================================================================
vim.opt.mouse = "a"         -- Enable mouse support
vim.opt.number = true       -- Show line numbers
vim.opt.showmatch = true    -- Highlight matching brackets

-- ============================================================================
-- 4. INDENTATION & TABS
-- ============================================================================
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.tabstop = 2        -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2     -- Number of spaces for auto-indentation
vim.opt.softtabstop = 2    -- Number of spaces inserted/deleted on <Tab>/<BS>

-- ============================================================================
-- 5. PLUGIN GLOBAL VARIABLES
-- ============================================================================
vim.g.NERDCustomDelimiters = { c = { left = "//", right = "" } }

-- ============================================================================
-- 6. KEY MAPPINGS
-- ============================================================================
local map = vim.keymap.set

-- File Explorer (NvimTree)
map("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })

-- Telescope Fuzzy Finder Mappings
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find Files by name" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Search text inside project (grep)" })
map("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Search Vim help tags" })

-- Native LSP Mappings
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
map("n", "D", vim.lsp.buf.hover, { desc = "Show Hover Documentation" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show Diagnostics Line Float" })

-- ============================================================================
-- 7. AUTOCMDS
-- ============================================================================
-- Prepend ':///' to comments for Rust, C, and C++ files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rs", "c", "cpp" },
  callback = function()
    vim.opt_local.comments:prepend(":///")
  end,
})

-- ============================================================================
-- 8. NATIVE LSP & DIAGNOSTICS CONFIGURATION (Neovim 0.11+)
-- ============================================================================

-- Diagnostic settings
vim.diagnostic.config({
  virtual_text = false,     -- Disables inline text on lines
  signs = true,             -- Shows icons in the gutter for errors/warnings
  underline = true,         -- Underlines code issues
  update_in_insert = false, -- Wait until exiting insert mode / saving to run diagnostics
})

-- Completion Engine Setup (nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

-- Pass autocompletion capabilities to all servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- C / C++ / GLib Language Server
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
  },
})
vim.lsp.enable("clangd")

-- Rust Language Server
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = {
        command = "clippy", -- Runs cargo clippy on save for diagnostic checks
      },
    },
  },
})
vim.lsp.enable("rust_analyzer")

vim.opt.updatetime = 300

-- Print error/warning message at the very bottom of Neovim (under status bar)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

    if not vim.tbl_isempty(diagnostics) then
      local diag = diagnostics[1]
      -- Choose highlight group based on severity (Error vs Warning)
      local hl = (diag.severity == vim.diagnostic.severity.ERROR) and "ErrorMsg" or "WarningMsg"

      -- Print single-line summary to avoid "Press ENTER to continue" prompts
      local first_line = diag.message:match("([^\n]+)") or diag.message
      vim.api.nvim_echo({ { "LSP: " .. first_line, hl } }, false, {})
    else
      -- Clear the command area when moving away from an error
      vim.api.nvim_echo({ { "", "None" } }, false, {})
    end
  end,
})

-- ============================================================================
-- 9. COLORS
-- ============================================================================

vim.cmd("colorscheme onehalfdark")

local hl = vim.api.nvim_set_hl

local bg = '#303030'
local bg_hl = '#98c379'
local comments_fg = '#626262'

hl(0, "Normal", { bg = bg })
hl(0, "NormalFloat", { bg = bg })
hl(0, "SignColumn", { bg = bg })
hl(0, "NvimTreeNormal", { bg = bg })
hl(0, "LineNr", { bg = bg, fg = comments_fg })
hl(0, "Comment", { fg = comments_fg })
hl(0, "StatusLine", { bg = bg_hl, fg = bg })
hl(0, "StatusLineNC", { bg = bg, fg = bg_hl })
hl(0, "WinSeparator", { bg = bg, fg = comments_fg })

-- LSP diagnostic floating window background and border
hl(0, "NormalFloat", { fg = "#afafaf", bg = "#3a3a3a" })
--- Autocompletion pop-up
hl(0, "Pmenu", { fg = "#afafaf", bg = "#3a3a3a" })
