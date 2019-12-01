export ZSH=/root/.oh-my-zsh

export VAR="hall"
# The following lines were added by compinstall
#
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 3
zstyle :compinstall filename '/home/dali/.zshrc'

autoload -Uz compinit
compinit
MODULES=(git, tmux)


# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
#


#ZSH_THEME="powerlevel9k/powelevel9k"
ZSH_THEME="agnoster"
ZSH_THEME="lukerandall"

plugins=(
  git
)
alias gs=gst

source $ZSH/oh-my-zsh.sh

alias setproj="echo \$(pwd) > /home/dali/.current_project"

cd $(cat /home/dali/.current_project)

#[[ $TERM != "screen" ]] && exec tmux 
export XDG_RUNTIME_DIR="/run/user/1000"
export VAR="hall"
