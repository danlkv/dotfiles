function fish_greeting
	echo ""
end

abbr -a glo "git log --graph --decorate --topo-order --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=format:'%C(cyan)%h%Creset %C(black bold)%ad %C(dim yellow)(%an) %Creset%C(auto)%d %s'"
abbr -a gl "git log --decorate --color --graph --all  --pretty=format:'%C(yellow)%h %Cred%ad %Creset%s%x09%Cblue%an%Cgreen%d ' --date=relative"
#git config --global alias.lg "log --graph --decorate -30 --topo-order --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=format:'%C(cyan)%h%Creset %C(black bold)%ad %C(dim yellow)(%an) %Creset%C(auto)%d %s'"

# -- Vim keybindings
fish_vi_key_bindings

source ~/.config/fish/dir_stack.fish
# < dir stack >
# Key bindings
bind -M insert \cb dir_back     
bind -M insert \cn dir_forward 

# Optional: Add abbreviations for easier access
abbr --add db dir_back
abbr --add df dir_forward
abbr --add ds dir_stack_show
abbr --add dc dir_stack_clear

# </ dir stack >


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
# -- C-a - go to line start (emacs,bash)
bind -s  -M default \cA beginning-of-line
bind -s  -M insert \cA beginning-of-line


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

  # -- Movements
  # -- -m ensures that we don't exit the mode (without it we exit into default)
  # ---- C-f - "Go to next word" (emacs,bash)
  bind -s  -M default -m default \ef forward-word
  bind -s  -M insert -m insert \ef forward-word 
  # ---- C-b - "Go to previous word" (emacs,bash)
  bind -s  -M default -m default \eb backward-word
  bind -s  -M insert -m insert \eb backward-word 
end

#source $HOME/.config/danlkv_platforms/$(hostname)
