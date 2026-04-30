#!/bin/bash

# ==========================================
# Configuration
# ==========================================
# IMPORTANT: Replace this with your actual Linux username
TARGET_USER="system"

MONITOR="eDP-1"
AC_PROFILE="1920x1080@144"
BATTERY_PROFILE="1920x1080@60"
POSITION="0x0"
SCALE="1"

# ==========================================
# Environment Setup
# ==========================================
# Find the user's ID to locate the Wayland socket
USER_ID=$(id -u "$TARGET_USER")
export XDG_RUNTIME_DIR="/run/user/$USER_ID"

# Find the active Hyprland instance signature
# Hyprland stores its socket in /tmp/hypr/ or $XDG_RUNTIME_DIR/hypr/
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr/ 2>/dev/null | head -n 1)

if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Fallback to XDG_RUNTIME_DIR if not in /tmp
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 "$XDG_RUNTIME_DIR/hypr/" 2>/dev/null | head -n 1)
fi

# ==========================================
# Logic
# ==========================================
# Read the current state of the AC adapter
AC_ONLINE=$(cat /sys/class/power_supply/*/online 2>/dev/null | head -n 1)

# Function to run hyprctl as the target user
run_hyprctl() {
    su - "$TARGET_USER" -c "export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR; export HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE; hyprctl keyword monitor \"$1\""
}

if [ "$AC_ONLINE" -eq 1 ]; then
    # Plugged in
    run_hyprctl "$MONITOR,$AC_PROFILE,$POSITION,$SCALE"
else
    # On Battery
    run_hyprctl "$MONITOR,$BATTERY_PROFILE,$POSITION,$SCALE"
fi
