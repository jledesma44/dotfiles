#!/bin/bash
#
#
# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "######################################################################################"
echo -e "                ${YELLOW}!!  INSTALLING BASE PACKAGES !!${NC}                        "
echo -e "######################################################################################"

# Install base packages from the per-distro list matching this machine's package manager.
list_dir=~/.dotfiles/shared/2.Package-lists

to_install=()
unavailable=()

if command -v apt-get >/dev/null 2>&1; then
    pkg_list="$list_dir/basepkg_debian.txt"
    install_cmd=(sudo apt-get install --no-upgrade -y)
    sudo apt-get update
    while read -r pkg; do
        case "$pkg" in ""|\#*) continue ;; esac
        if [ "$(dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null)" = "install ok installed" ]; then
            echo -e "${GREEN}$pkg is already installed, skipping${NC}"
        elif apt-cache show "$pkg" >/dev/null 2>&1; then
            to_install+=("$pkg")
        else
            unavailable+=("$pkg")
        fi
    done < "$pkg_list"
elif command -v pacman >/dev/null 2>&1; then
    pkg_list="$list_dir/basepkg_arch.txt"
    install_cmd=(sudo pacman -S --noconfirm --needed)
    sudo pacman -Syu --noconfirm
    while read -r pkg; do
        case "$pkg" in ""|\#*) continue ;; esac
        if pacman -Qq "$pkg" >/dev/null 2>&1; then
            echo -e "${GREEN}$pkg is already installed, skipping${NC}"
        elif pacman -Si "$pkg" >/dev/null 2>&1; then
            to_install+=("$pkg")
        else
            unavailable+=("$pkg")
        fi
    done < "$pkg_list"
else
    echo -e "${YELLOW}No apt or pacman found, skipping base package install${NC}"
    exit 0
fi

if [ ${#to_install[@]} -gt 0 ]; then
    echo -e "${YELLOW}Installing: ${to_install[*]}${NC}"
    "${install_cmd[@]}" "${to_install[@]}" || exit 1
else
    echo -e "${GREEN}All available packages are already installed${NC}"
fi

if [ ${#unavailable[@]} -gt 0 ]; then
    echo -e "${RED}Not found in package repositories, skipped: ${unavailable[*]}${NC}"
fi
