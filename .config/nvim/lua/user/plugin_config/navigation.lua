-- optionally enable 24-bit colour
vim.opt.termguicolors = true
-- Tabs
vim.keymap.set('n', 'tj', 'gt')
vim.keymap.set('n', 'tk', 'gT')



-- Nvim Tree
--
-- disable netrw at the very start of your init.lua
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1


-- OR setup with some options
--local nvim_tree = require 'nvim-tree'
--nvim_tree.setup({
--   sort = {
--       sorter = "case_sensitive",
--   },
--   on_attach = nvim_tree_attach,
--   view = {
--       width = 30,
--   },
--   renderer = { group_empty = true, },
--   filters = { dotfiles = false, },
--})

return {

  -- < Context > --
  { 
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
    keys = {
      { "<leader>u", function() require("treesitter-context").go_to_context(vim.v.count1) end, mode={"n", "v"}, desc = "Go to context" },
    },
    event = { "BufReadPost", "BufNewFile" },
  },
  -- </ Context > --

  -- < Outline > --
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>s", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
  -- </ Outline > --

  -- < Aerial > --
  -- Similar to outline but more features
  {
    'stevearc/aerial.nvim',
    opts = {
      nav= { 
        keymaps = {
          ["q"] = "actions.close",
          ["<esc>"] = "actions.close",
        }
      }
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>at", "<cmd>AerialToggle<CR>", mode={"n", "v"}, desc = "Toggle Aerial" },
      { "<leader>an", "<cmd>AerialNavToggle<CR>", mode={"n", "v"}, desc = "Toggle Aerial Nav" },
    },
  },
  -- </ Aerial > --

  -- Tree explorer
  --
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    event = {
      "VeryLazy",
    },
    keys = {
      { "<c-n>", "<cmd>Neotree toggle<cr>",        mode={"n", "v"}, desc = "Neotree toggle" },
      -- To trigger standard vim "go to next location", use <ctrl-shift-i>
      --{ "<c-l>", "<cmd>Neotree toggle reveal<cr>", desc = "Neotree current file" },
      { "<leader>b", "<cmd>Neotree toggle show buffers right<cr>", desc = "Neotree buffers" },
      { "<leader>B", "<cmd>Neotree toggle show buffers right focus<cr>", desc = "Neotree buffers focus" },
    },
    opts = {
      auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            --renamed = "󰁕", -- this can only be used in the git_status source
            renamed = "", -- nf-oct-file-symlink-file
            -- Status type
            untracked = "◌",
            ignored = "",
            unstaged = "", 
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        width = 45,
        side = "left",
        -- :help neo-tree-mappings
        mappings = {
          ["<CR>"] = "open",
          ["<C-CR>"] = "open_with_window_picker",
          ["."] = "set_root",
          ["l"] = "open",
          ["h"] = "close_node",
          ["H"] = "navigate_up",
          ["<C-x>"] = "open_split",
          ["T"] = "open_tabnew",
          ["s"] = "open_vsplit",
          ["I"] = "toggle_hidden",
          ["z"] = "noop",
          -- the fuzzy-finder is redundant, there is Telescope
          ["/"] = "noop",
          ["t"] = "noop", -- conflicts with "gt"
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      -- Setup toggle/focus depending on neotree focus
      local manager = require("neo-tree.sources.manager")
      local function is_neotree_focused()
        local bufnr = vim.api.nvim_get_current_buf()
        for _, src in ipairs(require("neo-tree").config.sources) do
          local st = manager.get_state(src)
          if st and st.bufnr == bufnr then return true end
        end
        return false
      end
      local function focus_or_toggle()
        if is_neotree_focused() then
          vim.cmd("Neotree toggle reveal")
        else
          vim.cmd("Neotree focus reveal")
        end
      end

      ---- keymap
      vim.keymap.set("n", "<tab>", focus_or_toggle, {
        desc = "Neo-tree: focus if hidden / toggle if focused",
        silent = true,
      })
    end,
  },

  -- nelescope
  --
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    event = "VeryLazy",
    keys = {
      { '<c-P>',        '<cmd>Telescope cmdline<cr>', desc = 'Cmdline' },
      -- files
      { '<leader>te',   '<cmd>Telescope file_browser<cr>', desc = 'Files' },
      { '<c-t>',        '<cmd>Telescope find_files hidden=true<cr>', desc = 'All files' },
      { '<leader>tg',   '<cmd>Telescope live_grep<cr>', desc = 'Files search' },
      { '<leader>tb',   '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
      -- LSP
      { '<leader>ts>',        '<cmd>Telescope lsp_document_symbols<cr>', desc = 'LSP Symbols' },
      { '<leader>tr',   '<cmd>Telescope lsp_references<cr>', desc='LSP references'},
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jonarrien/telescope-cmdline.nvim',
    },

    config = function()
      -- Telescope
      local telescope_builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>tf', function()
        telescope_builtin.find_files({
          find_command = { 'fd', '--hidden', '--follow', '--type', 'f' } })
      end, {})
      vim.keymap.set('n', '<leader>th', telescope_builtin.help_tags, {})
      vim.keymap.set('n', '<leader>tc', telescope_builtin.command_history, {})


      local telescope_actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          -- :help telescope.defaults.file_ignore_patterns*
          -- Note: will also ignore *any* results (including lsp)
          -- Rationale: I don't want to always ignore .gitignore files.
          --      Sometimes I want to view ignored files, such as lock/env files.
          file_ignore_patterns = {
            "node_modules/.*",
            ".git/.*",
            ".gitlab/.*",
          },
          mappings = {
            i = {
              ["<C-j>"] = telescope_actions.move_selection_next,
              ["<C-k>"] = telescope_actions.move_selection_previous,
              -- Conflicts with "delete word"
              -- ["<C-w>"] = telescope_actions.close,
            },
            n = {
              ["<C-c>"] = telescope_actions.close,
            },
          },
          winblend = 30,
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
          },
          border = true,
          sorting_strategy = "ascending",
        },
        extensions = {
          cmdline = {
            picker   = {
              layout_config = {
                width  = 120,
                height = 25,
              }
            },
            mappings = {
              complete      = '<Tab>',
              run_selection = '<C-CR>',
              run_input     = '<CR>',
            },
          },
        }
      }
    end
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  -- < Telescope
  {
    "cbochs/portal.nvim",
    -- Optional dependencies
    cmd = { "Portal" },
    keys = {
      {"<leader>o", "<cmd>Portal jumplist backward<cr>", desc = "Backward portal"},
      {"<leader>i", "<cmd>Portal jumplist forward<cr>", desc = "Forward portal"},
    },
    opts = {
      labels = { "u", "h", "e", "t", "o", "n"}, 
      window_options = {
        height = 4,
      },
    },
    dependencies = {
      "cbochs/grapple.nvim",
      --"ThePrimeagen/harpoon"
    },
  }

}
