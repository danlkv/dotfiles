#!/bin/bash
#
sess=`tmux display-message -p '#S'`
set="tmux set-option -t $sess"
echo "sess:" $sess
if [ $THEME_ADAPTIVE == "dark" ]
then
    echo "dark"
    $set status-bg '#000506'
    $set window-status-current-style bg='#000f0f',fg='#606060'
    $set window-status-style bg='#070516',fg='#404020'
    tmux set-env -t $sess THEME_ADAPTIVE dark
    # Active Pane
else
    echo "light"
    $set status-bg '#f0e5f6'
    $set window-status-current-style bg='#f0ffff',fg='#606060'
    $set window-status-style bg='#f7f5f6',fg='#404020'
    $set message-style fg='#fff1fb',bg='#686f9a'
    tmux set-env -t $sess THEME_ADAPTIVE light
fi
