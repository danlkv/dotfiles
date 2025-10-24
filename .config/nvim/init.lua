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
vim.opt.linebreak = true

-- Folding (see https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/)
vim.o.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
function _G.first_two_lines()
  local line1 = vim.fn.getline(vim.v.foldstart)
  local line2 = vim.fn.getline(vim.v.foldstart + 1)
  -- For line separator, use unicode character for carriage return: ↩
  return line1 .. " ↩ " .. line2
end
vim.opt.foldtext = "v:lua.first_two_lines()"
vim.opt.foldnestmax = 4
vim.o.foldlevelstart = 3
vim.o.foldlevel = 4
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
--vim.keymap.set('n', '<c-v>', '"+p', { silent = true })
vim.keymap.set('c', '<c-v>', '<c-r>+', { silent = true })
vim.keymap.set('i', '<c-v>', '<c-o>"+p', { silent = true })




-- https://janneinosaka.blogspot.com/2014/10/automatically-resize-vim-splits.html
-- Function to mimic Janne’s Splitresize()
function Splitresize()
    local win = vim.api.nvim_get_current_win()
    local col = vim.o.columns
    local line = vim.o.lines

    -- Width
    local origwidth = vim.fn.winwidth(0)
    -- local propwidth = math.floor(col * 2 / 3)
    local hmin = 80 --math.max(origwidth, math.floor(col * 2 / 3), 80)
    local final_w = math.max(hmin, origwidth)

    -- Height
    local vmax = math.max(vim.fn.winheight(0), math.floor(line * 2 / 3), 25)

    local final_h = math.min(vmax, 60)

    vim.cmd("vertical resize " .. final_w)
    vim.cmd("resize " .. final_h)

    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_current_win(win)
    end
    vim.o.cmdheight = 1
end

-- Map <C-h/j/k/l> to move and then resize the split
for _, dir in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("n", "<C-" .. dir .. ">", "<C-W>" .. dir .. ":lua Splitresize()<CR>", { silent = true })
end

vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
    vim.cmd 'wincmd ='
    end
})

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



vim.keymap.set("n",    "<leader>h",
    function()
        local result = vim.treesitter.get_captures_at_cursor(0)
        print(vim.inspect(result))
    end,
    { noremap = true, silent = false }
)


require 'user'
require 'neovide'
require 'my_modules.transparent'
require 'my_modules.colors'

-- FIXME: this does not work, when I open files the indentexpr is not to treesitter.
-- Also ftplugin doesn't work.
-- https://vi.stackexchange.com/questions/8824/in-what-order-does-vim-read-ftplugin-files-syntax-files-and-the-vimrc-when-f
-- Filetype specific
-- cpp
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp,cc,hpp,cu,h',
  callback = function()
    -- set indentexpr=
    vim.opt.indentexpr = ''
  end,
})

-- FIXME: this does not work, when I open files the formatoptions contain o
vim.opt.formatoptions:remove('o')

-- Temporary fix to the above, to be called manually
function OwriteSettings()
    vim.opt.indentexpr = ''
    vim.opt.formatoptions:remove('o')
end
