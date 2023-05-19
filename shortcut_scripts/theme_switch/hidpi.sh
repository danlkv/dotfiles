gitbuild=$HOME/git-built
confdir=$HOME/.config
cd $gitbuild/st
stfontsize=36
wezfontsize=30

# ST
# change fontsize in config.h to $stfontsize without knowing current font size
sed -i "s/pixelsize \?= \?[0-9]\+/pixelsize=$stfontsize/g" config.h
echo "* Changed st font size to $stfontsize in $gitbuild/st/config.h"
sudo make install > /dev/null
echo "* Installed st with font size $stfontsize"

# Wezterm
cd $confdir/wezterm
sed -i "s/font_size \?= \?[0-9.]\+/font_size=$wezfontsize/g" wezterm.lua
echo "* Changed wezterm font size to $wezfontsize in $confdir/wezterm/wezterm.lua"

# Picom
cd $confdir/picom
# change corner radius to 25
corner_radius=30
sed -i "s/corner-radius \?= \?[0-9]\+/corner-radius = $corner_radius/g" picom.conf
echo "* Changed picom corner radius to $corner_radius in $confdir/picom/picom.conf"

# i3
cd $confdir/i3
# change corner radius to 25
gaps=32
gaps_outer='-8'
sed -i "s/gaps inner [-0-9]\+/gaps inner $gaps/g" config
sed -i "s/gaps outer [-0-9]\+/gaps outer $gaps_outer/g" config
echo "* Changed i3 gaps to $gaps in $confdir/i3/config"
i3-msg reload > /dev/null
echo "* Reloaded i3"


# qutebrowser
qtb_conf=$confdir/qutebrowser/config.py
# change corner radius to 25
qutebrowser_font=24pt
qutebrowser_zoom=170%
sed -i "s/c.zoom.default \? = \?.\+/c.zoom.default = '$qutebrowser_zoom'/g" $qtb_conf
echo "* Changed qutebrowser zoom to $qutebrowser_zoom in $qtb_conf"
sed -i "s/c.fonts.default_size \? = \?.\+/c.fonts.default_size = '$qutebrowser_font'/g" $qtb_conf
echo "* Changed qutebrowser font size to $qutebrowser_font in $qtb_conf"
echo "*! Press any key to restart qutebrowser."
read -t 3 -n 1
if [ $? = 0 ]; then
    qutebrowser :restart --nowindow > /dev/null
    echo "* Restarted qutebrowser"
else
    echo "* Timeout after 3 seconds. Restart qutebrowser manually to apply changes."
fi

