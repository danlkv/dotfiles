-- Run nvim with the command:
-- nvim -u init_svelte.lua
--
-- Plugins are located in lua/plugins.lua

require('plugins')
-- Install plugins.lua update
vim.cmd [[PackerCompile]]

vim.cmd([[
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]])

-- Basic config
vim.g.mapleader = ' '
vim.o.updatetime = 150
vim.o.termguicolors = true

vim.o.hidden = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.keymap.set('n','tj', 'gt')
vim.keymap.set('n','tk', 'gT')
-- Core

local telescope = require('telescope.builtin')
require 'nvim-tree_config'

local lspconfig = require('lspconfig')
local function on_attach(client, bufnr)
    print('Attaching to ' .. client.name)
        -- Server capabilities spec:
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
        })
    end
end
lspconfig.tsserver.setup{on_attach=on_attach}
lspconfig.svelte.setup{on_attach=on_attach}
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "scss", "json", "lua", "svelte" },
    auto_install = true,
    highlight = {
        enable = true,
    },
}
--lspconfig.lua_ls.setup{}
local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

-- Displays hover information about the symbol under the cursor
bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

-- Jump to the definition
bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

-- Jump to declaration
bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

-- Lists all the implementations for the symbol under the cursor
bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

-- Jumps to the definition of the type symbol
bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

-- Lists all the references 
bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')


-- Color config
vim.o.background = 'light'
require 'gruvbox'.setup {
    contrast = "hard",
}
require 'catppuccin'.setup {
    flavour = 'latte',
    transparent_background = true,
    styles = {
        functions = {'italic', 'bold'},
    },
    color_overrides = {
        latte = {
            base = '#fcf5f3', 
            mantle = '#feeeea',
            crust = '#f7ddd2',
        }
    }

}
vim.cmd [[colorscheme catppuccin]]
vim.cmd [[hi LspReferenceWrite guibg=lightblue
hi LspReferenceRead  guibg='#f7fcea']]

require('lualine').setup {
    options = {
        theme = 'catppuccin'
    }
}
