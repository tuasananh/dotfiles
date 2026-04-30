#!/bin/bash

# Determine the active backlight. 
# Checking directory existence does NOT wake the dGPU.
if [ -d /sys/class/backlight/intel_backlight ]; then
    DEVICE="intel_backlight"
elif [ -d /sys/class/backlight/nvidia_0 ]; then
    DEVICE="nvidia_0"
else
    exit 0
fi

# Function to read and output JSON for Waybar
get_backlight() {
    PERC=$(brightnessctl -m -d "$DEVICE" i | awk -F, '{print $4}' | tr -d '%')
    echo "{\"percentage\": $PERC}" || exit 0
}

# Print the initial value immediately
get_backlight

# Continuously monitor the specific brightness file for changes
inotifywait -m -q -e modify /sys/class/backlight/"$DEVICE"/brightness | while read -r line; do
    get_backlight
done
