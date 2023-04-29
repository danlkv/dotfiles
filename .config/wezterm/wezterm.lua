local wezterm = require 'wezterm'
local config = {}


config.font_size = 20.0

thememap = {
    dark = "Catppuccin Macchiato",
    light = "Catppuccin Latte"
}
theme_mode = 'dark'
config.color_scheme = thememap[theme_mode]

return config
