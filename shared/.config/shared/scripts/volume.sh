#!/bin/bash

# Usage: ./volume.sh output|input [up/down/mute]
TARGET=$1
ACTION=$2
AMOUNT=${3:-1}
STEP="${AMOUNT}%"

# Determine the ID based on the target
if [ "$TARGET" == "output" ]; then
    ID="@DEFAULT_AUDIO_SINK@"
elif [ "$TARGET" == "input" ]; then
    ID="@DEFAULT_AUDIO_SOURCE@"
else
    echo "Usage: $0 {output|input} {up|down|mute}"
    exit 1
fi

case "$ACTION" in
    up)
        # Increases volume, capped at 100%
        wpctl set-volume -l 1.0 "$ID" "$STEP+"
        ;;
    down)
        wpctl set-volume "$ID" "$STEP-"
        ;;
    mute)
        wpctl set-mute "$ID" toggle
        ;;
    *)
        echo "Usage: $0 {output|input} {up|down|mute}"
        exit 1
        ;;
esac
