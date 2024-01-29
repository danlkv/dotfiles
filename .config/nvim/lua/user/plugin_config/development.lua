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
            require 'flexoki' -- Fix to load colors before git
            local neogit = require 'neogit'
            neogit.setup {}
            vim.keymap.set('n', '<leader>gs', neogit.open)
        end
    },



    -- Testing
    {
        "nvim-neotest/neotest",
        enabled = false,
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
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                },
            })
        end

    },
}
