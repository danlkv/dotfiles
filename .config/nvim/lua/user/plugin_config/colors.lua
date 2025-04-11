-- Colorscheme config
--
--- Change this id
Colorscheme_id = 3

Colorscheme_names = {
    [1] = { 'flexoki', 'Paper-like white minimalistic' },
    [2] = { 'melange', 'Warm chocolate wood' },
    [3] = { 'rose-pine', 'Rosy' },
    -- Add new theme here, don't forget the config
}
--- Whether to apply the overrides
Colorscheme_override = true

function wsl_dark_theme_check()
    local property_path = "\"HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize\""
    local cmd = "powershell.exe"
    local args = "Get-ItemProperty -Path " .. property_path .. "-Name AppsUseLightTheme"
    local complete = vim.system({cmd, args}, {text = true}):wait();
    if (complete.code ~= 0) then
        print(complete.stderr)
    end
    if string.find(complete.stdout, 'AppsUseLightTheme : 0') then
        return true
    elseif string.find(complete.stdout, 'AppsUseLightTheme : 1') then
        return false
    else
        print("Invalid WSL output: " .. complete.stdout)
    end
end


Theme_monitor_timer = nil
function Stop_theme_monitor()
    -- call Theme_monitor_timer:stop() to cancel the monitor
    if Theme_monitor_timer ~= nil then
        Theme_monitor_timer:stop()
        print('Theme monitor stopped')
    end
end
function Start_theme_monitor(request_theme)
    -- Run every second a callback that checks system theme
    -- and updates colorscheme
    local interval = 1000
    Theme_monitor_timer = vim.loop.new_timer()
    local theme = vim.o.background
    local callback = function()
        -- manually changed background, stop timer
        if vim.o.background ~= theme then
            Stop_theme_monitor()
        end

        local system_theme = request_theme() and 'dark' or 'light'
        -- system theme changed
        if theme ~= system_theme then
            vim.o.background = system_theme
            Colors_override_fn(Colorscheme_names[Colorscheme_id][1])
            theme = system_theme
        end
    end
    Theme_monitor_timer:start(interval, interval, vim.schedule_wrap(callback))
end

function set_host_specific_config()
    local hostname = vim.loop.os_gethostname()
    local host_functions = {
        ["Your-Home-Hostname"] = function() end,
        ["LAPTOP-112LK02F"] = function()
            Start_theme_monitor(wsl_dark_theme_check)
        end
    }
    if host_functions[hostname] then
        host_functions[hostname]()
    end
end

set_host_specific_config()

function Colors_override_fn(name)
    if not Colorscheme_override then
        return
    end
    local override_background = false
    -- Light
    if vim.o.background == 'light' then
        if override_background then
            vim.api.nvim_set_hl(0, 'Normal', { bg = "#fcf5f3", fg = "#1d2023" })
            vim.cmd 'highlight! BorderBG guibg=None guifg=#706560'
            vim.api.nvim_set_hl(0, 'Number', { bg = "#feeae5", fg = '#3d4543' })
            vim.api.nvim_set_hl(0, 'Comment', { bg = "#fef2da", fg = "#444f24" })

            vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = "#2f552f" })
            vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = "#552f2f" })
            vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = "#555125" })
        end

        if name == 'flexoki' then
            vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#feebe6" })
            vim.api.nvim_set_hl(0, 'CursorColumn', { bg = "#feeeea" })
            vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "#271179" })
            vim.api.nvim_set_hl(0, 'String', { bg = "#f5f5f8", fg = "#41697a" })
            vim.api.nvim_set_hl(1, 'Delimiter', { bg = "#fcf4e9", fg = "#0090a0" })
        end
    elseif vim.o.background == 'dark' then
        -- Dark
        if override_background then
            vim.api.nvim_set_hl(0, 'Normal', { bg = "#020306", fg = "#ecf1c1" })
        end

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

-- set colorscheme
vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    callback = function()
        vim.cmd.colorscheme(colorscheme_name)
        Colors_override_fn(colorscheme_name)
    end
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
    },

   ['rose-pine'] = {
        "rose-pine/neovim",
        name = "rose-pine",
    },

    flexoki = {
        -- original: "kepano/flexoki-neovim", but this supports opt.bg
        "nuvic/flexoki-nvim",
        name = "flexoki",
        config = function(_, opts)
            require('flexoki').setup(opts)
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
    -- extra installs
    colorscheme_configs['flexoki'],
    colorscheme_configs['melange'],
    --colorscheme_configs['rose_pine'],

    {
        "Mofiqul/vscode.nvim",
        opts = {
            italic_comments = true,
        }
    },
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
    {
        "RRethy/vim-illuminate",

        -- event = { "VeryLazy" },
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
                --theme = 'auto',
                --theme = 'gruvbox',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                globalstatus = false,
                refresh = {
                    statusline = 300,
                    tabline = 300,
                    winbar = 300,
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
                lualine_c = { {'filename', path = 1 } },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
        },
    config = function(_, opts)
      vim.opt.fillchars = {
        stl = "─",
        stlnc = "─",
      }
      require('lualine').setup(opts)
    end
  },

  -- Treesitter
  --
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function(_, opts)
      --setup treesitter
      treesitter = require 'nvim-treesitter.configs'
      treesitter.setup({
        ensure_installed = { "c", "python", "rust", "lua", "vim", "vimdoc", "javascript", "html", "svelte",
          "typescript", "css" },
        sync_install = false,
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-g>",
            node_incremental = "<c-x>l",
            node_decremental = "<c-x>h",
            scope_incremental = "<c-x>r",
          },
        },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      })
    end,

  },

  -- Rainbow delimiters
  --
  {
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
