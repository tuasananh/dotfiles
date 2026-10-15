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
export EHU57_535510N_1D='DAD8BC6E-D0EC-4423-9FEE-20AB679D7ABB-1782223881646_1782223881646'
export EHU57_70K3N='PLpt91USzRlluCq2duoZ-V2'
export HUST_SESSION_ID='8861C59F-AC33-48F4-B986-C2A7898B7EBF-1784183696223_1784183696223'
export HUST_TOKEN='PLpt91USzRlluCq2duoZ-V2'

# Added by the Postman CLI installer
export PATH='/home/tuasananh/.local/bin':"$PATH"
