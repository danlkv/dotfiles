function SetColors()
    vim.api.nvim_set_hl(0, 'Normal', { bg = "#fcf5f3" })
    vim.cmd 'highlight! BorderBG guibg=None guifg=#706560'
    vim.api.nvim_set_hl(0, 'Number', { bg = "#feeae5", fg = '#3d4543' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#feebe6" })
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = "#feeeea" })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "#271179" })
    vim.api.nvim_set_hl(0, 'Comment', { bg = "#fef2da", fg = "#444f24" })
    vim.api.nvim_set_hl(0, 'String', { bg = "#f5f5f8", fg = "#41697a" })
    vim.api.nvim_set_hl(0, 'Delimiter', { bg = "#fcf4e9", fg = "#0090a0" })
end
