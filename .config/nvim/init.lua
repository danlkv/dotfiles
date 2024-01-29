-- Leader shortcut
vim.g.mapleader = ' '

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true


vim.keymap.set('n', '<c-s>', ':update<cr>', { silent = true })

require 'user'
