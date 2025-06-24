#!/bin/bash

THEME=${THEME:-light}

if [[ $THEME = "light" ]]; then
    tmux set -g status-bg "#eeeeee"
    echo "Turned on $THEME theme"
else
    tmux set -g status-bg "#111111"
    echo "Turned on $THEME theme"
fi 
