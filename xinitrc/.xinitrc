# X server settings
setroot $DESKTOP
setxkbmap -option caps:escape
xrdb -load ~/.Xresources

# Window manager daemons
unclutter -noevents -idle 3 &
urxvtd -q -o &
xcompmgr -c -C -o.0 &

exec i3
