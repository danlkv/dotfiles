# Dotfiles and configs


## Fish shell

1. Fisher plugin manager
2. `fd` for file search
3. `ripgrep` (also used in nvim)
4. [fzf fish](https://github.com/PatrickF1/fzf.fish)

    - Install via `install_scripts/fzf.fish`
    - Needs special tmux configuration
    - Default config:

            set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
    - My config: change height to 42%, follow symlinks, ignore `node_modules`

