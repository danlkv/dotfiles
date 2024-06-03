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
    "nvim-tree/nvim-tree.lua",
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
        'hrsh7th/cmp-nvim-lsp',
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    -- #
    --- Vim search highlighting tweak
    { "romainl/vim-cool" },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    {
        "ray-x/lsp_signature.nvim",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
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
