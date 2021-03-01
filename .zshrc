export ZSH=$HOME/.oh-my-zsh
export TERM=xterm
source ~/.profile

export VAR="hall"
# The following lines were added by compinstall
#
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 3
zstyle :compinstall filename $HOME/.zshrc
export PATH=$HOME/.local/bin:$PATH
export PATH=/home/danlkv/anl/Qensor/qtree/thirdparty/tamaki_treewidth:$PATH
export LD_LIBRARY_PATH=/home/danlkv/.local/lib/libffi/lib64:/home/danlkv/.local/lib:$LD_LIBRARY_PATH


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

plugins=(
  git
)
alias gs=gst
alias vim=nvim

source $ZSH/oh-my-zsh.sh

alias setproj="echo \$(pwd) > $HOME/.current_project"

cd $(cat $HOME/.current_project)

#[[ $TERM != "screen" ]] && exec tmux 
export XDG_RUNTIME_DIR="/run/user/1000"
export VAR="hall"

