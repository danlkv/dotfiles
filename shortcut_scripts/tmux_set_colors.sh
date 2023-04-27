#!/bin/bash
#
sess=`tmux display-message -p '#S'`
set="tmux set-option -t $sess"
setwin="tmux set-window-option -g"
echo "Tmux session:" $sess


if [ $THEME_ADAPTIVE == "dark" ]
then
    echo "dark"
    $set status-bg '#000506'
    $setwin window-status-current-style bg='#000f0f',fg='#606060'
    $setwin window-status-last-style bg='#070516',fg='#505040'
    $setwin window-status-style bg='#070516',fg='#404020'
    tmux set-env -t $sess THEME_ADAPTIVE dark
    # Active Pane
else
    echo "light"
    $set status-bg '#f0e5f6'
    $set message-style fg='#fff1fb',bg='#686f9a'

    $setwin window-status-current-style bg='#f0ffff',fg='#606060'
    $setwin window-status-last-style bg='#f7f5f5',fg='#505040'
    $setwin window-status-style default
    $setwin window-status-activity-style none,bg='#f9e9f9',fg='#505040'
    tmux set-env -t $sess THEME_ADAPTIVE light
fi
