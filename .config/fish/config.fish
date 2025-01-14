function fish_greeting
	echo ""
end

abbr -a glo "git log --graph --decorate --topo-order --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=format:'%C(cyan)%h%Creset %C(black bold)%ad %C(dim yellow)(%an) %Creset%C(auto)%d %s'"
abbr -a gl "git log --decorate --color --graph --all  --pretty=format:'%C(yellow)%h %Cred%ad %Creset%s%x09%Cblue%an%Cgreen%d ' --date=relative"
git config --global alias.lg "log --graph --decorate -30 --topo-order --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=format:'%C(cyan)%h%Creset %C(black bold)%ad %C(dim yellow)(%an) %Creset%C(auto)%d %s'"

alias vim=nvim
alias tmux="tmux -2"
alias clip="xclip -selection 'clipboard'"
# -- C-s acts as "accept suggestion"
bind -s  -M default \cs end-of-line
bind -s  -M insert \cs end-of-line 
# -- C-e acts as "accept suggestion"
bind -s  -M default \ce end-of-line
bind -s  -M insert \ce end-of-line
bind \cs end-of-line
# -- C-a acts as "Go to first character" (emacs,bash)
bind -s  -M default \cA beginning-of-line
bind -s  -M insert \cA beginning-of-line

# -- Vim keybindings
fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here

    # -- Check if fzf is installed
    if functions -q fzf_configure_bindings
        # -- Configure fzf
        export FZF_DEFAULT_OPTS='--height 40%'

        bind -M insert \cP _fzf_search_history
        bind -M default \cP _fzf_search_history
    else
        bind -M insert \cP up-or-search
        bind -M default \cP up-or-search
    end

    bind -M insert \cE end-of-line
    bind -s  -M default \cA beginning-of-line
    bind -s  -M insert \cA beginning-of-line
end

#source $HOME/.config/danlkv_platforms/$(hostname)
