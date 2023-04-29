#c.tabs.position = "left"
config.load_autoconfig()
import importlib
theme = importlib.import_module('qutebrowser-theme')
c.zoom.default = '185%'
c.fonts.default_size = '20pt'

def set_dark_mode(c):
    theme.setup(c, 'macchiato', True)
    c.colors.webpage.preferred_color_scheme = 'dark'
    c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
    c.colors.webpage.darkmode.contrast = 0.0
    c.colors.webpage.darkmode.enabled = True
    c.colors.webpage.darkmode.grayscale.all = False
    c.colors.webpage.darkmode.grayscale.images = 0.0
    c.colors.webpage.darkmode.policy.images = 'smart'
    c.colors.webpage.darkmode.policy.page = 'smart'
    c.colors.webpage.darkmode.threshold.background = 128
    c.colors.webpage.darkmode.threshold.text = 128 

    dark_mode_mode = 'auto'
    if dark_mode_mode == 'css':
        c.content.user_stylesheets = ['solarized-dark-all-sites.css']
        c.colors.webpage.darkmode.enabled = True
    else:
        c.content.user_stylesheets = []
        c.colors.webpage.darkmode.enabled = True


def set_light_mode(c):
    theme.setup(c, 'latte', True)
    c.colors.webpage.darkmode.enabled = False

theme_mode = 'dark'
{
    'dark': set_dark_mode,
    'light': set_light_mode
}[theme_mode](c)
