local wezterm = require 'wezterm'
local config = {}

config.default_domain = 'WSL:Arch'

config.max_fps = 144

config.font_size = 12.0
config.window_background_opacity = 0.7
config.freetype_load_target = "HorizontalLcd"
config.font = wezterm.font("Iosevka Curly Slab", { weight = 'Light' })
config.font = wezterm.font("ZedMono NF", { weight = 'Light' })
-- Condensed
config.font = wezterm.font("Iosevka NF", { weight = 'Light' })
-- Serif
config.font = wezterm.font("Triplicate T4", { weight = 'Light' })
config.font = wezterm.font("Go Mono", { weight = 'Light' })
-- Serif condensed
config.font = wezterm.font("Xanh Mono")
-- Sans condensed
--config.font = wezterm.font("M+ 1m")
config.font = wezterm.font("64-SRC-Medium")
config.font = wezterm.font("Victor Mono")
config.font = wezterm.font("Iosevka Curly Slab", { weight = 'Medium' })


-- Broken
--config.font = wezterm.font("LMMonoLt10-Regular") 
--
--config.font = wezterm.font("LMMono10-Regular", { weight = 'Light' })
--config.font = wezterm.font("Symbols Nerd Font Mono", { weight = 'Light' })
--config.font = wezterm.font("Hack Nerd Font", { weight = 'Light' })

config.color_scheme_dirs = { 'C:\\Users\\Alhazen\\.config\\wezterm\\colors' }
thememap = {
    catppuccin = {
        dark = "Catppuccin Macchiato",
        light = "Catppuccin Latte"
    },
    flexoki = {
        dark = "Flexoki Dark",
        light = "Flexoki Light"
    },
    melange = {
        dark = "melange_dark",
        light = "melange_light",
    },
}


local theme = 'flexoki'
local appearance_themes = {
  Light = thememap[theme].light,
  Dark =  thememap[theme].dark,
}
local appearance = wezterm.gui.get_appearance()
local theme_bar = appearance == "Dark" and "dark" or "light"
--config.color_scheme = thememap[theme_mode]
local rose_pine = wezterm.plugin.require('https://github.com/neapsix/wezterm')
local _theme_map_rose = {light = "dawn", dark = "main"}
local theme = rose_pine[_theme_map_rose[theme_bar]]
local bar_themes = {
    light = {
        active_tab =        { bg_color = "#eeeeee", fg_color = "#111111" },
        inactive_tab =      { bg_color = "#e0e0e0", fg_color = "#666666" },
        inactive_tab_hover ={ bg_color = "#eeeeee", fg_color = "#111111" },
        new_tab =           { bg_color = "#eeeeee", fg_color = "#222222" },
        new_tab_hover =     { bg_color = "#ffffff", fg_color = "#222222" }
    },
    dark = {
        active_tab =        { fg_color = "#ffffff", bg_color = "#111111" },
        inactive_tab =      { fg_color = "#eeeeee", bg_color = "#111111" },
        inactive_tab_hover ={ fg_color = "#eeeeee", bg_color = "#111111" },
        new_tab =           { fg_color = "#eeeeee", bg_color = "#222222" },
        new_tab_hover =     { fg_color = "#ffffff", bg_color = "#111111" }
    },
}

config.color_scheme = appearance_themes[appearance] or dark_theme
--config.colors = { background = "#ffffff" }
config.window_frame = theme.window_frame()
config.window_frame.font = wezterm.font({ family = "Iosevka Aile", weight = "Regular" })
config.colors = {
    tab_bar = bar_themes[theme_bar],
}
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- Tmux-like shortcuts
config.leader = { key="h", mods="CTRL" }
config.keys = {
    { key = "g", mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x01"}},
    { key = "[", mods = "LEADER",       action=wezterm.action.ActivateCopyMode},
    { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "|", mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "s", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "v", mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "o", mods = "LEADER",       action="TogglePaneZoomState" },
    { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    { key = "h", mods = "LEADER|CTRL",  action=wezterm.action{ActivatePaneDirection="Left"}},
    { key = "j", mods = "LEADER|CTRL",  action=wezterm.action{ActivatePaneDirection="Down"}},
    { key = "k", mods = "LEADER|CTRL",  action=wezterm.action{ActivatePaneDirection="Up"}},
    { key = "l", mods = "LEADER|CTRL",  action=wezterm.action{ActivatePaneDirection="Right"}},
    { key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
    { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
    { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
    { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
    { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
    { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
    { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
    { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
    { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
    { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
    { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
    { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
    { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
    { key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
    { key = "d", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
    { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
}
--

return config
