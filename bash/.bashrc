# ~/.bashrc
eval "$(starship init bash)"

export EDITOR=nvim

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(zoxide init bash)"

# [[ ${BLE_VERSION-} ]] && ble-attach
EMSDK_QUIET=1 . "/usr/local/lib/emsdk/emsdk_env.sh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export NEWT_COLORS="root=default,default:window=default,default:border=#cba6f7,default:shadow=default,default:title=#cba6f7,default:actbutton=#cdd6f4,#313244:button=#1e1e2e,#cba6f7:compactbutton=#cdd6f4,#313244:checkbox=#cdd6f4,#313244:actcheckbox=#1e1e2e,#cba6f7:entry=#cdd6f4,#313244:label=#cdd6f4,default:listbox=#cdd6f4,default:actlistbox=#1e1e2e,#cba6f7:sellistbox=#1e1e2e,#cba6f7:actsellistbox=#1e1e2e,#cba6f7:textbox=#cdd6f4,default:acttextbox=#1e1e2e,#cba6f7:helpline=default,default:roottext=default,default"

function y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || exit
  rm -f -- "$tmp"
}

source -- /usr/share/blesh/ble.sh

cp_cc() {
  # Define ANSI color codes
  local GREEN='\033[1;32m'
  local RED='\033[1;31m'
  local CYAN='\033[1;36m'
  local YELLOW='\033[1;33m'
  local NC='\033[0m' # No Color

  # Check if a filename was provided
  if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: cp_cc <filename.cpp>${NC}"
    return 1
  fi

  local filename="$1"
  local basename="${filename%.*}"

  echo -e "${CYAN}Compiling $filename...${NC}"

  # Run g++ directly inside the if condition
  if g++ -std=c++23 -DLOCAL -O2 -g3 -Wall -Wextra -Wshadow -Wconversion \
    -Wlogical-op -Wfloat-equal -Wduplicated-cond \
    -fsanitize=address,undefined -fno-sanitize-recover=all \
    -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I/home/tuasananh/coding/CP/ \
    "$filename" -o "$basename"; then

    echo -e "${GREEN}✅ Compilation succeeded! File output: ./$basename${NC}"
    return 0
  else
    echo -e "${RED}❌ Compilation failed.${NC}"
    return 1
  fi
}

cp_run() {
  # Define ANSI color codes
  local GREEN='\033[1;32m'
  local RED='\033[1;31m'
  local YELLOW='\033[1;33m'
  local MAGENTA='\033[1;35m'
  local NC='\033[0m' # No Color

  # Check if a filename was provided
  if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: cp_run <filename.cpp>${NC}"
    return 1
  fi

  local filename="$1"
  local basename="${filename%.*}"

  # Compile the file using your colorful cp_cc function
  if ! cp_cc "$filename"; then
    # We don't need to print an error here because cp_cc already prints "❌ Compilation failed."
    return 1
  fi

  # Check if the executable was actually created
  if [ -f "$basename" ]; then
    echo -e "${MAGENTA}🚀 Running ./$basename...${NC}"
    echo -e "${MAGENTA}----------------------------------------${NC}"

    # Run the executable
    ./"$basename"

  else
    echo -e "${RED}❌ Executable not found.${NC}"
    return 1
  fi
}

# pnpm
export PNPM_HOME="/home/tuasananh/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export OLLAMA_API_KEY="ollama-local"
