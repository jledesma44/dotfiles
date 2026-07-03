#!/bin/zsh

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

PACMAN_LIST="$HOME/.dotfiles/2.Package-lists/pkglist_pacman.txt"
YAY_LIST="$HOME/.dotfiles/2.Package-lists/pkglist_yay.txt"

echo "######################################################################################"
echo -e "               ${YELLOW}!!  Package Installation / Updates !!${NC}                         "
echo "######################################################################################"

# Update and upgrade Arch linux repositories
echo -e "\n${BLUE}==> Updating system...${NC}"
sudo pacman -Syu --noconfirm

# Install/update packages from pacman list
echo -e "\n${BLUE}==> Installing pacman packages...${NC}"
sudo pacman -S --noconfirm --needed $(grep -v '^[[:space:]]*$' "$PACMAN_LIST")

# Install yay AUR helper if not already installed
if ! command -v yay &>/dev/null; then
    echo -e "\n${BLUE}==> Installing yay AUR helper...${NC}"
    sudo pacman -S --noconfirm --needed base-devel git
    BUILD_DIR=$(mktemp -d)
    if git clone https://aur.archlinux.org/yay-bin.git "$BUILD_DIR/yay-bin"; then
        if ! (cd "$BUILD_DIR/yay-bin" && makepkg -si --noconfirm); then
            echo -e "${RED}  Error: Failed to build/install yay-bin${NC}"
            rm -rf "$BUILD_DIR"
            exit 1
        fi
    else
        echo -e "${RED}  Error: Failed to clone yay-bin repository${NC}"
        rm -rf "$BUILD_DIR"
        exit 1
    fi
    rm -rf "$BUILD_DIR"
else
    echo -e "\n${BLUE}==> yay already installed, skipping clone/build...${NC}"
fi

# Install/update packages from yay/AUR list
echo -e "\n${BLUE}==> Installing AUR packages...${NC}"
yay -S --noconfirm --needed $(grep -v '^[[:space:]]*$' "$YAY_LIST")

# kmonad: allow running as user via exec-once
echo -e "\n${BLUE}==> Configuring kmonad permissions...${NC}"
if [[ -f /usr/bin/kmonad ]]; then
    sudo chmod u+s /usr/bin/kmonad
    sudo usermod -aG input "$USER"
else
    echo -e "${YELLOW}  kmonad not found at /usr/bin/kmonad, skipping permissions setup${NC}"
fi

echo -e "\n${GREEN}All packages have been installed and/or updated.${NC}"
