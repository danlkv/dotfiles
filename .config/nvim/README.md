# Danlkv's neovim config


## Colors

I get bored of the colorschemes pretty quickly.
Choosing a new one is also tedious, as you have to work with it to understand
if it is any good. 

So I have several vetted colorschemes saved in an array in
[`plugin_config/colors.lua`](lua/user/plugin_config/colors.lua). The config for
individual colorscheme plugin is stored there as well.

When I need a new theme, I just update the `Colorscheme_id`.

On top of that, I often like to modify some colors of existing theme. This is
[done](https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f) by
using an autocmd on `ColorScheme` event.

If the overrides don't work right now, you can call `lua
Colorscheme_override=false` and then `colorscheme ...` again.

### I dont want to

- Disable the old scheme and enable the new one
- Try to remember the name of colorscheme

### Potential limitations

- The configuration through `opts` may not work

### Improvements

- Reload on shortcut
    
    This can work if I set a parameter in `opts` so that `lazy.nvim` can detect
    the change.
