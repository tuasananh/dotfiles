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
  if g++ -std=c++23 -DLOCAL -O2 -g -Wall -Wextra -Wshadow -Wconversion \
    -Wlogical-op -Wfloat-equal -Wduplicated-cond \
    -fsanitize=address,undefined -fno-sanitize-recover=all \
    -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I/home/tuasananh/repos/CP/ \
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
