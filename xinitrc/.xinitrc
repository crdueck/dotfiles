# X server settings
setroot $DESKTOP
setxkbmap -option caps:escape
unclutter -noevents -idle 3 &
urxvtd -q -o &
xcompmgr -c -C -o.0 &
xrdb ~/.Xresources

# start window manager
xmonad
