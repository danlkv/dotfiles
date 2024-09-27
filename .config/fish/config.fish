function fish_greeting
	echo ""
end

abbr -a gl "git log --decorate --color --graph --all  --pretty=format:'%C(yellow)%h %Cred%ad %Creset%s%x09%Cblue%an%Cgreen%d ' --date=relative"
git config --global alias.lg "log --graph --decorate -30 --topo-order --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=format:'%C(cyan)%h%Creset %C(black bold)%ad %C(dim yellow)(%an) %Creset%C(auto)%d %s'"

alias vim=nvim
alias tmux="tmux -2"
alias clip="xclip -selection 'clipboard'"
# -- C-s acts as "accept suggestion"
bind -s --preset -M default \cs end-of-line
bind -s --preset -M default \ce end-of-line
bind \cs end-of-line
bind -s --preset -M insert \cs end-of-line 
bind -s --preset -M default \ce end-of-line

# -- Vim keybindings
fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here

    # -- Check if fzf is installed
    if functions -q fzf_configure_bindings
        bind -M insert \cP _fzf_search_history
    else
        bind -M insert \cP up-or-search
    end

    bind -M insert \cE end-of-line
end

#source $HOME/.config/danlkv_platforms/$(hostname)
