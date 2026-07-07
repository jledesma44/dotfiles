#!/bin/bash
#

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "######################################################################################"
echo "           ${YELLOW}!!  INSTALLING LATEST NEOVIM BUILD FROM SOURCE !!${NC}           "
echo "######################################################################################"

# Build and install the latest stable Neovim from source.
set -e

build_dir=$(mktemp -d)
git clone --depth 1 --branch stable https://github.com/neovim/neovim.git "$build_dir"
make -C "$build_dir" CMAKE_BUILD_TYPE=Release
sudo make -C "$build_dir" install
rm -rf "$build_dir"

echo "######################################################################################"
echo "       ${YELLOW}!!  Successfully installed $(nvim --version | head -n 1)!!${NC}      "
echo "######################################################################################"
