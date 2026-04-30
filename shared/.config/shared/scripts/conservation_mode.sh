#!/bin/bash

FILE="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

# Function 1: Get current status
get_status() {
    if [ ! -f "$FILE" ]; then
        echo "Error: Path not found. Is 'ideapad_acpi' loaded?"
        return 1
    fi
    STATUS=$(cat "$FILE")
    if [ "$STATUS" -eq 1 ]; then
        echo "Conservation Mode: ON (Battery limited to 60%)"
    else
        echo "Conservation Mode: OFF (Full charging enabled)"
    fi
}

# Function 2: Set status
set_status() {
    local VAL=$1
    if [[ "$VAL" != "1" && "$VAL" != "0" ]]; then
        echo "Usage: set [on|1] or [off|0]"
        return 1
    fi
    echo "$VAL" | sudo tee "$FILE" > /dev/null
    echo "Successfully set to: $( [ "$VAL" -eq 1 ] && echo 'ON' || echo 'OFF' )"
}

# Function 3: Toggle status
toggle_status() {
    CURRENT=$(cat "$FILE")
    if [ "$CURRENT" -eq 1 ]; then
        set_status 0
    else
        set_status 1
    fi
}

# --- CLI Logic ---
# If no argument is provided ($# -eq 0), default to "get"
ACTION=${1:-get}

case "$ACTION" in
    get)
        get_status
        ;;
    set)
        case "$2" in
            on|1)  set_status 1 ;;
            off|0) set_status 0 ;;
            *)     echo "Usage: $0 set [on|off]" ;;
        esac
        ;;
    toggle)
        toggle_status
        ;;
    *)
        echo "Usage: $0 {get|set|toggle}"
        echo "Defaulting to 'get'..."
        get_status
        ;;
esac
