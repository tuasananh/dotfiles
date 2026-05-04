#!/bin/bash

# Ensure each package name in the file matches exactly
# -v: Invert match (exclude)
# -x: Match the whole line (prevents "lib" from excluding "libpulse")
# -f: Read patterns from the following file
yay -Qeq | grep -vxf excluded_packages | tee included_packages
