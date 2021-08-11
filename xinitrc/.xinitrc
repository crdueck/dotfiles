# X server settings
setroot $DESKTOP
setxkbmap -option caps:escape
xrdb -load ~/.Xresources

# Desktop daemons
unclutter -noevents -idle 3 &
urxvtd -q -o &

exec i3
