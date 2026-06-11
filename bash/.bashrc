# ~/.bashrc
export EDITOR=nvim

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if uwsm check may-start; then
  export UWSM_SILENT_START=1
  uwsm start hyprland.desktop
fi

# shellcheck disable=SC1094
[[ $- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none

# Source all scripts in ~/.bashrc.d/

if [ -d "$HOME/.bashrc.d" ]; then
  for script in "$HOME/.bashrc.d/"*; do
    if [ -f "$script" ] && [ -r "$script" ]; then
      # shellcheck disable=SC1090
      source "$script"
    fi
  done
fi

eval "$(zoxide init bash)"

# I did not configure emsdk
# EMSDK_QUIET=1 . "/usr/local/lib/emsdk/emsdk_env.sh"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

[[ ! ${BLE_VERSION-} ]] || ble-attach
