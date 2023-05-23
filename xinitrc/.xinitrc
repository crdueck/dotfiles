setroot --restore
unclutter --fork --timeout 3
setxkbmap -option caps:escape

exec xmonad
