#!/bin/bash
#
#
# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "######################################################################################"
echo "                ${YELLOW}!!  INSTALLING BASE PACKAGES !!${NC}                        "
echo "######################################################################################"

# Debian install packages script from txt file.
xargs -a ~/.dotfiles/shared/2.Package-lists/basepkg_list.txt sudo apt-get install --no-upgrade -y
