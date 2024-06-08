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
vim.keymap.set('n', '<c-t>', function() telescope_builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<c-j>', telescope_builtin.lsp_document_symbols, {})

local telescope_actions = require('telescope.actions')
require 'telescope'.setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = telescope_actions.move_selection_next,
                ["<C-k>"] = telescope_actions.move_selection_previous,
                ["<C-w>"] = telescope_actions.close,
            }
        },
    }
}


-- Nvim Tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<cr>', { silent = true, noremap = true })
vim.keymap.set('n', "<C-b>", ":NvimTreeFindFile<cr>", { silent = true, noremap = true })

local function nvim_tree_attach(bufnr)
    local api = require 'nvim-tree.api'

    local function edit_or_open()
        local node = api.tree.get_node_under_cursor()
        if node.nodes ~= nil then
            api.node.open.edit()
        else
            api.node.open.edit()
            -- api.tree.close()
        end
    end

    -- open as vsplit on current node
    local function vsplit_preview()
        local node = api.tree.get_node_under_cursor()
        if node.nodes ~= nil then
            api.node.open.edit()
        else
            api.node.open.edit()
        end
        api.tree.focus()
    end

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))

    vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
    vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))

    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
    vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Root Up'))
    vim.keymap.set('n', '+', api.tree.change_root_to_node, opts('Set root to Node'))

    vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
    vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
end

-- OR setup with some options
local nvim_tree = require 'nvim-tree'
nvim_tree.setup({
    sort = {
        sorter = "case_sensitive",
    },
    on_attach = nvim_tree_attach,
    view = {
        width = 30,
    },
    renderer = { group_empty = true, },
    filters = { dotfiles = false, },
})
