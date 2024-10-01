-- Leader shortcut
vim.g.mapleader = ' '

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.o.virtualedit = "block"

-- Folding (see https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/)
vim.o.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldnestmax = 4
vim.o.foldlevelstart = 1
vim.o.foldenable = true
-- vim.cmd 'set formatoptions+=a'

-- Search
vim.o.inccommand = "split"
vim.o.ignorecase = true

vim.keymap.set('n', '<c-s>', ':update<cr>', { silent = true })
vim.keymap.set('n', '<leader>s', vim.lsp.buf.format, { silent = true })
vim.keymap.set('n', '<leader>q', ':wq<cr>', { silent = true })
-- System clipboard
--- Copy
vim.keymap.set('n', '<c-c>', '"+y', { silent = true })
vim.keymap.set('v', '<c-c>', '"+y', { silent = true })
--- Paste
vim.keymap.set('n', '<c-v>', '"+p', { silent = true })
vim.keymap.set('c', '<c-v>', '<c-r>+', { silent = true })
vim.keymap.set('i', '<c-v>', '<c-o>"+p', { silent = true })



vim.api.nvim_create_autocmd('BufRead', {
    callback = function(opts)
        vim.api.nvim_create_autocmd('BufWinEnter', {
            once = true,
            buffer = opts.buf,
            callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                if
                    not (ft:match('commit') and ft:match('rebase'))
                    and last_known_line > 1
                    and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
                then
                    vim.api.nvim_feedkeys([[g`"]], 'nx', false)
                end
            end,
        })
    end,
})

require 'user'
require 'neovide'
require 'my_modules.transparent'
require 'my_modules.colors'
