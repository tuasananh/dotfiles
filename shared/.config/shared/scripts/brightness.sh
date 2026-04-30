#!/bin/bash

# Auto-detect the active backlight device
if [ -d /sys/class/backlight/intel_backlight ]; then
    DEVICE="intel_backlight"
elif [ -d /sys/class/backlight/nvidia_0 ]; then
    DEVICE="nvidia_0"
else
    echo "Error: No supported backlight device found."
    exit 1
fi

# Usage: ./brightness.sh up|down [amount]
ACTION=$1
AMOUNT=${2:-1}
STEP="${AMOUNT}%"

case "$ACTION" in
    up)
        # Increases brightness
        brightnessctl -d "$DEVICE" -q set "$STEP+"
        ;;
    down)
        # Decreases brightness, ensures it doesn't go below 1% 
        # (to prevent a completely black screen)
        brightnessctl -d "$DEVICE" -q set "$STEP-" --min-value=1
        ;;
    *)
        echo "Usage: $0 {up|down} [amount]"
        exit 1
        ;;
esac
