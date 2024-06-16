if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$(polybar -m|tail -l|sed -e 's/:.*$//g')
    # MONITOR=$m polybar --reload nero &
  done
else
  polybar --reload nero &
fi
