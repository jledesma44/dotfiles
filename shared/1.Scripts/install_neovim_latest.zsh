#!/bin/bash
#

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

set -e

# Skip the build if the installed Neovim already matches the latest stable release.
latest=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')

if command -v nvim >/dev/null 2>&1 && [ -n "$latest" ]; then
    installed=$(nvim --version | head -n 1 | awk '{print $2}')
    if [ "$installed" = "$latest" ]; then
        echo -e "######################################################################################"
        echo -e "       ${GREEN}!!  Neovim $installed is already the latest version, skipping build !!${NC}      "
        echo -e "######################################################################################"
        exit 0
    fi
fi

echo -e "######################################################################################"
echo -e "           ${YELLOW}!!  INSTALLING LATEST NEOVIM BUILD FROM SOURCE !!${NC}           "
echo -e "######################################################################################"

# Build and install the latest stable Neovim from source.
build_dir=$(mktemp -d)
git clone --depth 1 --branch stable https://github.com/neovim/neovim.git "$build_dir"
make -C "$build_dir" CMAKE_BUILD_TYPE=Release
sudo make -C "$build_dir" install
rm -rf "$build_dir"

echo -e "######################################################################################"
echo -e "       ${YELLOW}!!  Successfully installed $(nvim --version | head -n 1)!!${NC}      "
echo -e "######################################################################################"
