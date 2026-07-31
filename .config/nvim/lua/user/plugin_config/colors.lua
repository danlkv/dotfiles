-- Colorscheme config
--
--- Change this id
Colorscheme_id = 2

Colorscheme_names = {
    [1] = { 'flexoki', 'Paper-like white minimalistic' },
    [2] = { 'melange', 'Warm chocolate wood' },
    [3] = { 'rose-pine', 'Rosy' },
    -- Add new theme here, don't forget the config
}
--- Whether to apply the overrides
Colorscheme_override = true

function wsl_dark_theme_check_pwsh()
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

function wsl_dark_theme_check()
    local property_path = "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize"
    local cmd = "reg.exe"
    local args = {"query", property_path, "/v", "AppsUseLightTheme"}
    local complete = vim.system({cmd, unpack(args)}, {text = true}):wait();
    if (complete.code ~= 0) then
        print(complete.stderr)
    end
    local val = complete.stdout:match("AppsUseLightTheme%s+REG_DWORD%s+0x(%x+)")
    if not val then return end
    local is_light = tonumber(val, 16) == 1
    return not is_light
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
    local interval = 3000
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

function set_vim_diagnostics()
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '',
                [vim.diagnostic.severity.INFO] = '',
                [vim.diagnostic.severity.HINT] = '★',
            },
        }
    })
end

set_vim_diagnostics()


function Colors_override_fn(name)
    if not Colorscheme_override then
        return
    end
    local override_background = true
    -- Light
    if vim.o.background == 'light' then
        if override_background then
            --vim.api.nvim_set_hl(0, 'Normal', { bg = "#fcf5f3", fg = "#1d2023" })
            vim.api.nvim_set_hl(0, 'Normal', { bg = "#ffffff", fg = "#000000" })
            vim.cmd 'highlight! BorderBG guibg=None guifg=#706560'
            --vim.api.nvim_set_hl(0, 'Number', { bg = "#feeae5", fg = '#3d4543' })
            vim.api.nvim_set_hl(0, 'Comment', { bg = "#fff8ff", fg = "#596f08" })
            vim.api.nvim_set_hl(0, 'Function', { fg = "#792205" })
            vim.api.nvim_set_hl(0, '@function', { fg = "#792205" })
            vim.api.nvim_set_hl(0, 'Type', { fg = "#144365" })
            vim.api.nvim_set_hl(0, '@type', { fg = "#144365" })
            vim.api.nvim_set_hl(0, '@variable.member', { fg = "#004576" })

            vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = "#efffef" })
            vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = "#ffe0e0" })
            vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = "#ffefff" })

            vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#f8f8f3" })
            vim.api.nvim_set_hl(0, 'CursorColumn', { bg = "#faf5f5" })
            vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "#271179" })
        end

        if name == 'flexoki' then
            vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#fffbf6" })
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
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require('nvim-treesitter')
      local parsers = {
        "c", "python", "rust", "lua", "vim", "vimdoc", "javascript", "html",
        "svelte", "typescript", "css",
      }

      treesitter.setup({})
      treesitter.install(parsers)

      local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function(args)
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end

          -- Tree-sitter indentation breaks `gq` list continuation wrapping in
          -- Markdown, so retain its filetype indentation there.
          local filetype = vim.bo[args.buf].filetype
          if filetype ~= "markdown" and filetype ~= "markdown_inline" then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Incremental selection moved into Neovim core in 0.12.
      vim.keymap.set("n", "<c-g>", function()
        vim.treesitter.select("parent", vim.v.count1)
      end, { desc = "Start Tree-sitter selection" })
      vim.keymap.set("x", "<c-x>l", function()
        vim.treesitter.select("parent", vim.v.count1)
      end, { desc = "Select parent Tree-sitter node" })
      vim.keymap.set("x", "<c-x>h", function()
        vim.treesitter.select("child", vim.v.count1)
      end, { desc = "Select child Tree-sitter node" })
      vim.keymap.set("x", "<c-x>r", function()
        vim.treesitter.select("parent", vim.v.count1)
      end, { desc = "Select parent Tree-sitter node" })
    end,

  },

  -- Rainbow delimiters
  --
  {
    "hiphish/rainbow-delimiters.nvim",
    config = function(_, opts)
      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        condition = function(bufnr)
          local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
          return ok and parser ~= nil
        end,
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
