setroot --restore
unclutter --fork --ignore-scrolling --timeout 3
setxkbmap -option caps:escape

exec xmonad
