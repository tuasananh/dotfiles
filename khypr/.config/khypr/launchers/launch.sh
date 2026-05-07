#!/bin/sh

# Usage: launch.sh <file> [args]
#
# This should launch the app defined in <file> with the supplied args.
#
# The file should have the app in the first line. If the app needs a terminal, the second line must be "needs terminal"

CONFIG="$1"
shift
TERMINAL=$(cat ~/.config/khypr/settings/default-terminal)
NEEDS_TERMINAL=$(sed -n '2p' "$CONFIG")

# Get the raw command string from the first line
CMD=$(sed -n '1p' "$CONFIG")

# Use 'eval' so the shell properly parses the quotes inside $CMD.
# We wrap "$@" in single quotes so the literal string "$@" gets evaluated
# by eval, safely passing any extra arguments without breaking them.

if [ "$NEEDS_TERMINAL" = "needs terminal" ]; then
  eval exec "$TERMINAL" -e "$CMD" '"$@"'
elif [ "$NEEDS_TERMINAL" = "needs terminal hold" ]; then
  eval exec "$TERMINAL" -e --hold "$CMD" '"$@"'
else
  eval exec "$CMD" '"$@"'
fi
