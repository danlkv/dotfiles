### Dated: 2022-02-29
# 
set -l prefix "- [fzf.fish] - "
echo $prefix"Install fisher plugin manager"
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
echo $prefix"Install utilities"
yes | pacman -S fd bat ripgrep fzf
echo $prefix"Install fzf fish plugin https://github.com/PatrickF1/fzf.fish"
fisher install PatrickF1/fzf.fish

echo $prefix"Applying custom fzf settings"
set --export --universal FZF_DEFAULT_OPTS '--cycle --border --preview-window=wrap --marker="*"
--layout=reverse
--height=42%
'

echo $prefix"Configure fzf to use fd and follow symlinks"
set --export --universal FZF_DEFAULT_COMMAND 'fd --follow --type f'
set --universal fzf_fd_opts --follow --hidden --exclude node_modules

echo $prefix"Append to `~/.config/fish/config.fish` to configure fzf keybindings (needs reload)"
echo "fzf_configure_bindings --variables=\e\cv" >> ~/.config/fish/config.fish

echo -n $prefix"Keybindings:
    - Files: Ctrl + Alt + F
    - History: Ctrl + R
    - Git log: Ctrl + Alt + L
    - Variables: Ctrl + Alt + V
"

