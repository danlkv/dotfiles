-- Colorscheme config
--
--- Change this id
Colorscheme_id = 2

Colorscheme_names = {
    [1] = { 'flexoki', 'Paper-like white minimalistic' },
    [2] = { 'melange', 'Warm chocolate wood' },
    -- Add new theme here, don't forget the config
}
--- Whether to apply the overrides
Colorscheme_override = true

function Colors_override_fn(name)
    if not Colorscheme_override then
        return
    end
    -- Light
    if vim.o.background == 'light' then
        vim.api.nvim_set_hl(0, 'Normal', { bg = "#fcf5f3", fg = "#1d2023" })
        vim.cmd 'highlight! BorderBG guibg=None guifg=#706560'
        vim.api.nvim_set_hl(0, 'Number', { bg = "#feeae5", fg = '#3d4543' })
        vim.api.nvim_set_hl(0, 'Comment', { bg = "#fef2da", fg = "#444f24" })

        if name == 'flexoki' then
            vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#feebe6" })
            vim.api.nvim_set_hl(0, 'CursorColumn', { bg = "#feeeea" })
            vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "#271179" })
            vim.api.nvim_set_hl(0, 'String', { bg = "#f5f5f8", fg = "#41697a" })
            vim.api.nvim_set_hl(1, 'Delimiter', { bg = "#fcf4e9", fg = "#0090a0" })
        end
    elseif vim.o.background == 'dark' then
        -- Dark
        -- vim.api.nvim_set_hl(0, 'Normal', { bg = "#020306", fg = "#ecf1c1" })

        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = "#2f552f" })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = "#552f2f" })
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = "#555125" })
    end
end

local colorscheme_name = Colorscheme_names[Colorscheme_id][1]
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function() Colors_override_fn(colorscheme_name) end
})


--- Add new the theme config here
local colorscheme_configs = {
    theme_name = {
        "user/theme",
        config = function(_, opts)
            vim.cmd.colorscheme 'theme'
        end
    },

    melange = {
        "savq/melange-nvim",
        config = function(_, opts)
            vim.cmd.colorscheme 'melange'
        end
    },

    flexoki = {
        "kepano/flexoki-neovim",
        config = function(_, opts)
            vim.cmd('colorscheme flexoki-light')
            -- Git (Neogit)
            vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#dfeed0' })
            vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#eedfd0' })
            vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#eeeec0' })
            vim.api.nvim_set_hl(0, 'DiffText', { bg = '#eeeec0' })

            vim.keymap.set('n', '<leader>lr', ':Lazy reload flexoki-neovim<cr>')
        end
    },

}

local colorscheme_config = colorscheme_configs[colorscheme_name]

-- Other colors
return {

    -- Current colorscheme.
    colorscheme_config,

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- Autocomplete menu
    -- (size defined in editing.lua)
    {
        'hrsh7th/nvim-cmp',

        config = function(_, opts)
            --require 'flexoki' -- Workaround to set the custom colors
            vim.opt.pumblend = 15
            vim.api.nvim_set_hl(0, 'PmenuSel', { blend = 5 })
            vim.api.nvim_set_hl(0, 'Pmenu', { blend = 10 })
            local cmp = require 'cmp'
            -- https://github.com/hrsh7th/nvim-cmp/issues/671
            cmp.setup({
                window = {
                    documentation = cmp.config.window.bordered({
                        winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
                    }),
                    completion = cmp.config.window.bordered({
                        winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
                    }),
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 32)
                        return vim_item
                    end
                }
            })
            vim.cmd 'highlight! BorderBG guibg=None guifg=#706560'
        end
    },

    -- Illuminate
    --
    {
        "RRethy/vim-illuminate",

        event = { "VeryLazy" },
        config = function(_, opts)
            require('illuminate').configure({
                -- providers: provider used to get references in the buffer, ordered by priority
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                -- delay: delay in milliseconds
                delay = 40,
                -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
                filetypes_denylist = {
                    'dirbuf',
                    'dirvish',
                    'fugitive',
                },
                modes_denylist = {},
                modes_allowlist = {},
                under_cursor = true,
                large_file_cutoff = nil,
                large_file_overrides = nil,
                min_count_to_highlight = 2,
            })
        end

    },

    -- Status Line
    --
    {
        "SmiteshP/nvim-navic",

        --- Status line breadcrumbs
        opts = {
            icons = {
                File          = "󰈙 ",
                Module        = " ",
                Namespace     = "󰌗 ",
                Package       = " ",
                Class         = "󰌗 ",
                Method        = "󰆧 ",
                Property      = " ",
                Field         = " ",
                Constructor   = " ",
                Enum          = "󰕘",
                Interface     = "󰕘",
                Function      = "󰊕 ",
                Variable      = "󰆧 ",
                Constant      = "󰏿 ",
                String        = "󰀬 ",
                Number        = "󰎠 ",
                Boolean       = "◩ ",
                Array         = "󰅪 ",
                Object        = "󰅩 ",
                Key           = "󰌋 ",
                Null          = "󰟢 ",
                EnumMember    = " ",
                Struct        = "󰌗 ",
                Event         = " ",
                Operator      = "󰆕 ",
                TypeParameter = "󰊄 ",
            },
            lsp = {
                auto_attach = true,
                preference = nil,
            },
            highlight = false,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true,
            lazy_update_context = false,
            click = false,
            format_text = function(text)
                return text
            end,
        }
    },
    {

        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        -- vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        opts = {
            options = {
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename', 'navic' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
        }
    }, {



    -- Treesitter
    --
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function(_, opts)
        --setup treesitter
        treesitter = require 'nvim-treesitter.configs'
        treesitter.setup({
            ensure_installed = { "c", "python", "rust", "lua", "vim", "vimdoc", "javascript", "html", "svelte" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            auto_install = true,
        })
    end,


}, {

    -- Rainbow delimiters
    --
    "hiphish/rainbow-delimiters.nvim",
    config = function(_, opts)
        local rainbow_delimiters = require 'rainbow-delimiters'

        vim.g.rainbow_delimiters = {
            strategy = {
                [''] = rainbow_delimiters.strategy['global'],
                vim = rainbow_delimiters.strategy['local'],
            },
            query = {
                [''] = 'rainbow-delimiters',
                lua = 'rainbow-blocks',
            },
            priority = {
                [''] = 110,
                lua = 210,
            },
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterGreen',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            },
        }
    end
}
}
