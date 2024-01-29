-- https://github.com/xiyaowong/transparent.nvim/blob/main/lua/transparent/config.lua
--
-- :luatext % to reload this file

local hi_groups_color = {
    ['guibg=default'] = {
        'Normal', 'Delimiter', 'LineNr', 'NonText',
        'CursorColumn', 'VertSplit', 'WinSeparator'
    },

    -- separate set for syntax text
    ['guibg=default '] = {
        'Comment', 'String',
    },
    -- ['guibg=#e8e0e0'] = {'CursorLine', 'CursorColumn'},
    ['guibg=default gui=underline'] = { 'CursorLine', },
}

function Set_transparent()
    for color, groups in pairs(hi_groups_color) do
        for _, g in pairs(groups) do
            vim.cmd("hi " .. g .. " " .. color)
        end
    end
end
