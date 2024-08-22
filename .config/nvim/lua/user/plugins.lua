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
        }
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
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
        event = { "VeryLazy" },
        'hrsh7th/nvim-cmp',
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        event = { "VeryLazy" },
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    -- #
    {
        "ray-x/lsp_signature.nvim",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    --- Vim search highlighting tweak
    { "romainl/vim-cool" },

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
