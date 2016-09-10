# X server settings
xrdb ~/.Xresources
imlibsetroot -s f $DESKTOP
setxkbmap -option caps:escape
unclutter -noevents -idle 3 &
urxvtd -q -o &

# start window manager
xmonad
