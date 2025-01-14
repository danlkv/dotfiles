-- Neovide configuration
--
-- Docs: https://neovide.dev/configuration.html

-- Cursor and animation settings

vim.g.neovide_cursor_smooth_blink = true
vim.opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_scroll_animation_lenght = 0.1

vim.g.neovide_position_animation_length = 0.08

-- Floating window settings

vim.g.neovide_floating_blur_amount_x = 5.0
vim.g.neovide_floating_blur_amount_y = 5.0


-- Font settings
vim.opt.guifont = "Iosevka Curly Slab:h11:w0.3"
vim.opt.linespace = 2

-- Scaling adjustment keybindings

vim.g.neovide_scale_factor = 1.3
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.1)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.1)
end)

vim.keymap.set("n", "<M-f>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end)
