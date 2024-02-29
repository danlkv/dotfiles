-- Git
return {
    {
        "NeogitOrg/neogit",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
        },
        init = function()
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



    -- Testing
    {
        "nvim-neotest/neotest",
        enabled = true,
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python"
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
            vim.keymap.set("n", "<leader>tv", function() neotest.summary.open() end)
        end

    },

    -- Python
    {
        'psf/black'
    },
}
