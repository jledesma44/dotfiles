#Removing old config files to be replaced by once from dotfiles

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "######################################################################################"
echo "                ${YELLOW}!!  Removing old config files !!${NC}                                   "
echo "######################################################################################"
rm -rf ~/.zshrc ~/.bashrc ~/.config/kitty ~/.config/hypr
