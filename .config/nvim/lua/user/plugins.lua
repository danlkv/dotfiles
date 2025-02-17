local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",     -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Function to get hostname
local function get_hostname()
  return vim.loop.os_uname().nodename
end

-- Determine Obsidian workspace path based on hostname
local hostname = get_hostname()
local obsidian_path

if hostname == "Your-Home-Hostname" then
  obsidian_path = "/path/to/home/notes"
elseif hostname == "Your-Work-Hostname" then
  obsidian_path = "/path/to/work/notes"
else
  obsidian_path = "/mnt/h/My Drive/Notes"  -- default path
end

require("lazy").setup({
  -- Colors and syntax
  { import = 'user.plugin_config.colors' },

  -- Navigation
  { import = 'user.plugin_config.navigation' },

  -- Editing
  { import = 'user.plugin_config.editing' },
  -- {
  --  'nmac427/guess-indent.nvim',
  -- },
  -- Misc

  ---- Vim search highlighting tweak
  { "romainl/vim-cool" },
  ---- Zen mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      width = 95,
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  --- Languages
  ----- Markdown preview
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        -- Provide your location to the browser
        --   print('load')
        --app = "google chrome"
        app = "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
        --app = "/mnt/c/Program Files/Mozilla Firefox/firefox.exe",
      })
      vim.api.nvim_create_user_command("MarkdownOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("MarkdownClose", require("peek").close, {})
    end,
  },
  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end
  },

  ---- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*",     -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = obsidian_path,
        },
      },

      -- see below for full list of options 👇
    },
  },

  ---- folding
  --    { 'kevinhwang91/nvim-ufo',                  dependencies = 'kevinhwang91/promise-async' },

  -- Development
  { import = 'user.plugin_config.development' },

}, {
  defaults = { lazy = false, },
  profiling = { loader = false },
  change_detection = {
    enabled = true,
    notify = false,
  },
}
)
