local wezterm = require 'wezterm'
local config = {}


config.font_size = 26.0
config.font = wezterm.font("Iosevka Slab", { weight = 'Light' })

thememap = {
    dark = "Catppuccin Macchiato",
    light = "Catppuccin Latte"
}
theme_mode = 'dark'
config.color_scheme = thememap[theme_mode]

return config
