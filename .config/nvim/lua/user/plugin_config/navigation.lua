-- optionally enable 24-bit colour
vim.opt.termguicolors = true
-- Tabs
vim.keymap.set('n', 'tj', 'gt')
vim.keymap.set('n', 'tk', 'gT')

-- Telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', function()
    telescope_builtin.find_files({
        find_command = { 'fd', '--hidden', '--follow', '--type', 'f' } })
end, {})
vim.keymap.set('n', '<leader>tg', function() telescope_builtin.live_grep({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>tb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>th', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>tc', telescope_builtin.command_history, {})
---- Telescope lsp jumps
vim.keymap.set('n', '<leader>tr', telescope_builtin.lsp_references)
vim.keymap.set('n', '<leader>ts', telescope_builtin.lsp_document_symbols)
vim.keymap.set('n', '<c-t>', function() telescope_builtin.find_files({ hidden = true, no_ignore=true}) end, {})
vim.keymap.set('n', '<c-j>', telescope_builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<c-k>', ":Telescope file_browser<cr>", {})


local telescope_actions = require('telescope.actions')
require 'telescope'.setup {
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
            }
        },
        winblend = 30,
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


-- Nvim Tree
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
