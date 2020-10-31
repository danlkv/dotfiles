# This file depends on settings in .Xmodmap
xmodmap /home/dali/.Xmodmap

# Use Spacebar as a Modifier
spare_modifier="Hyper_L" 
xmodmap -e "keycode 65 = $spare_modifier"   
xmodmap -e "add Hyper_L = $spare_modifier"
xmodmap -e "keycode any = space"  
xcape -e "$spare_modifier=space"

export XDG_RUNTIME_DIR="/run/user/1000"
export PATH="$PATH:/home/dali/.yarn/bin"
export MOZ_USE_XINPUT2=1
