local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    -- Colors and syntax
    { import = 'user.plugin_config.colors' },

    -- Navigation
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        event = {
            "VeryLazy",
        },
        keys = {
            { "<c-n>", "<cmd>Neotree toggle<cr>", desc = "Neotree" },
        },
        opts = {
            auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
            window = {
                width = 45,
                side = "left",
                mappings = {
                    ["<CR>"] = "open",
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["H"] = "navigate_up",
                    ["<C-x>"] = "open_split",
                    ["s"] = "open_vsplit",
                },
            },

        },
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        event = "VeryLazy",
        keys = {
            { ':', '<cmd>Telescope cmdline<cr>', desc = 'Cmdline' }
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'jonarrien/telescope-cmdline.nvim',
        }
    },
    {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },


    -- Editing
    --- Uncomment the two plugins below if you want to manage the language servers from neovim
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'VonHeikemen/lsp-zero.nvim',         branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'github/copilot.vim' },
    -- {'L3MON4D3/LuaSnip'},
    --- Editing lua configuration files
    {
        "folke/lazydev.nvim",
        ft = "lua",
    },
    {
        event = { "InsertEnter" },
        'hrsh7th/nvim-cmp',
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup({
                sources = {
                    { name = "lazydev" },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    }),

                })

            })
        end
    },
    -- #
    {
        "ray-x/lsp_signature.nvim",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    -- Misc

    ---- Vim search highlighting tweak
    { "romainl/vim-cool" },
    ---- Zen mode
    {
        "folke/zen-mode.nvim",
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
                app = "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
                --app = "/mnt/c/Program Files/Mozilla Firefox/firefox.exe",
            })
            vim.api.nvim_create_user_command("MarkdownOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("MarkdownClose", require("peek").close, {})
        end,
    },
    {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end
    },

    ---- Obsidian
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
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
                    path = "/mnt/h/My Drive/Notes/",
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
