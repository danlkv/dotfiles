-- Leader shortcut
vim.g.mapleader = ' '

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- vim.cmd 'set formatoptions+=a'

vim.keymap.set('n', '<c-s>', ':update<cr>', { silent = true })
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
if vim.g.neovide then
    require 'neovide'
end
require 'my_modules.transparent'
