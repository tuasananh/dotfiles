#!/bin/sh

# Usage: launch.sh <file> [args]
#
# This should launch the app defined in <file> with the supplied args.
#
# The file should have the app in the first line. If the app needs a terminal, the second line must be "needs terminal"
#
# For example, launching yazi, the file must be:
#
# ```
# yazi
# needs terminal
# ```
#
# Launching brave, the file must be:
#
# ```
# brave
# ```

CONFIG="$1"
shift
TERMINAL=$(cat ~/.config/khypr/settings/default-terminal)
NEEDS_TERMINAL=$(sed -n '2p' "$CONFIG")

# shellcheck disable=SC2046
set -- $(sed -n '1p' "$CONFIG") "$@"

if [ "$NEEDS_TERMINAL" = "needs terminal" ]; then
  exec "$TERMINAL" -e "$@"
else
  exec "$@"
fi
