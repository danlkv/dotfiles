-- Git
return {
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

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- extract method, rename var
  -- { import = "user.plugin_config.plugins.refactoring-nvim" },

  -- Sessions
  {
    "Shatur/neovim-session-manager",
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
