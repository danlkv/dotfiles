-- Autocomplete menu

vim.opt.pumheight = 10
-- LSP
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
    lsp_zero.buffer_autoformat()

    -- Svelte
    -- https://github.com/sveltejs/language-tools/issues/2008
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.js", "*.ts" },
        callback = function(ctx)
            if client.name == "svelte" then
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end
        end,
    })
end)


--Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
        },
    },
})

--Mason-LSP Setup
require("mason-lspconfig").setup({
    handlers = {
        lsp_zero.default_setup
    },
    ensure_installed = {
        "lua_ls",
        --"cssls",
        --"jsonls",
        --"pyright",
        --"tsserver",
        --"eslint",
        --"html",
        --"svelte",
        "rust_analyzer",
    },
})

require 'lsp_signature'.setup {
    hint_prefix = ' '
}
require('user.plugin_config.languages')

-- Folding

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- Auto-open float using built-in Lua API
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end
})
-- set cursorhold time
vim.o.updatetime = 500



-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
--vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
--vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
--vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]


-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
--local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities
        -- you can add other fields for setting up lsp server in this table
    })
end
--require('ufo').setup()
