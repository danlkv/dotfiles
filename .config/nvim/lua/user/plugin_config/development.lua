-- Git
return {
  {
    {'akinsho/toggleterm.nvim', version = "*", opts = {
      open_mapping = [[<c-\>]],
    }}
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "NeogitOrg/neogit",
    --event = "VeryLazy",
    keys = { "gs" },
    event = { "CmdlineEnter" },
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {}
      vim.keymap.set('n', '<leader>gs', function() neogit.open({ kind = "split" }) end)
    end
  },

  { -- Requires `silicon` to be installed
    "krivahtoo/silicon.nvim",
    build = "./install.sh",
    cmd = { "Silicon" },
    opts = {
      -- silicon --list-fonts
      font = "JetBrains Mono=21",
      -- silicon --list-themes
      theme = "Solarized (light)",
      background = "#fff",
      line_pad = 1,
      pad_horiz = 20,
      pad_vert = 15,
      gobble = true,
      window_controls = false,
      output = {
        clipboard = false,
        path = "/home/danlkv/Screenshots"
      },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -------------------------------------------------------------------------------
  -- Populates project-wide lsp diagnostics, regardless of what files are opened.

  {
    "artemave/workspace-diagnostics.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "folke/trouble.nvim",
    },
    config = function()
      require("workspace-diagnostics").setup({
        workspace_files = function()                -- Customize this function to return project files.
          return vim.fn.systemlist("git ls-files")  -- Example to get files from Git.
        end,
        -- Add any other configuration options as needed.
      })

      vim.api.nvim_set_keymap('n', '<space>x', '', {
        noremap = true,
        callback = function()
          for _, client in ipairs(vim.lsp.get_clients()) do
            require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
          end
        end,
        desc = "Populate workspace diagnostics"
      })
    end,
  },

  -- extract method, rename var
  -- { import = "user.plugin_config.plugins.refactoring-nvim" },

  -- Sessions
  {
    'rmagatti/auto-session',
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>sr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
      { '<leader>ss', '<cmd>SessionSave<CR>', desc = 'Save session' },
      { '<leader>sa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      cwd_change_handling = true,

      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        previewer = false,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { "i", "<C-D>" },
          alternate_session = { "i", "<C-S>" },
          copy_session = { "i", "<C-Y>" },
        },
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        theme_conf = {
          border = true,
          -- layout_config = {
          --   width = 0.8, -- Can set width and height as percent of window
          --   height = 0.5,
          -- },
        },
      },
    }
  }
  ,
  {
    "Shatur/neovim-session-manager",
    enabled = false,
    config = function()
      session_manager = require("session_manager")
      local config = require('session_manager.config')
      session_manager.setup({
        sessions_dir = vim.fn.stdpath('data') .. '/sessions', -- The directory where the session files will be saved.
        autoload_mode = config.AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. See "Autoload mode" section below.
        autosave_last_session = true, -- Automatically save last session on exit and on session switch.
        autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
        autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
        autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
          'gitcommit',
          'gitrebase',
        },
        autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
        autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
        max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
      })
      -- Auto save session
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        callback = function ()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == 'nofile' then
              return
            end
          end
          session_manager.save_current_session()
        end
      })
    end
  },
  {
    'FabijanZulj/blame.nvim',
    cmd = "BlameToggle",
    opts = {
      blame_options = { '-w' },
    },
  },


  -- Testing
  {
    "nvim-neotest/neotest",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function(_, opts)
      vim.g.python_host_skip_check = 1
      vim.g.loaded_python3_provider = 1
      vim.g.python3_host_skip_check = 1
      neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { '-s' },
          }),
        },
        default_strategy = "integrated",
        output = {
          open_on_run = true,
          enter = true
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 25"
        },
        summary = {
          open = "botright vsplit | vertical resize 35"
        }
      })
      vim.keymap.set("n", "<leader>tn", function() neotest.run.run(vim.fn.expand("%")) end)
      vim.keymap.set("n", "<leader>to", function() neotest.output_panel.open() end)
      vim.keymap.set("n", "<leader>tw", function() neotest.watch.toggle(vim.fn.expand("%")) end)
      vim.keymap.set("n", "<leader>tv", function() neotest.summary.toggle() end)
    end

  },

}
