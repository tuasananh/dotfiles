#!/bin/bash

if ! mkdir /tmp/refresh_toggle_lock 2>/dev/null; then
  exit 0
fi

# Tell the system to delete this lock in the background after 3 seconds
(
  sleep 3
  rmdir /tmp/refresh_toggle_lock
) &

MONITOR="eDP-1"
RESOLUTION="2560x1600" # Update this to your native resolution
POSITION="auto"
SCALE="1"

if hyprctl monitors | grep "$MONITOR" -A 1 | tail -n 1 | grep -q "@240"; then
  # Currently at 240Hz -> Switch to 60Hz
  hyprctl keyword monitor "$MONITOR,$RESOLUTION@60,$POSITION,$SCALE"
  notify-send -t 5000 "Display" "Switched to 60Hz"
else
  # Currently at 60Hz -> Switch to 240Hz
  hyprctl keyword monitor "$MONITOR,$RESOLUTION@240,$POSITION,$SCALE"
  notify-send -t 5000 "Display" "Switched to 240Hz"
fi
