#!/usr/bin/zsh

# Script to open/toggle bluetui in a floating kitty window on Hyprland

# Toggle: if already open, close it
if hyprctl clients -j | grep -q '"class": "floating-bluetui"'; then
  hyprctl dispatch closewindow class:floating-bluetui
  exit 0
fi

# Check if kitty is installed
if ! command -v kitty &>/dev/null; then
  echo "kitty is not installed!"
  exit 1
fi

# Check if bluetui is installed
if ! command -v bluetui &>/dev/null; then
  echo "bluetui is not installed!"
  echo "Install it with: yay -S bluetui-bin"
  exit 1
fi

# Launch bluetui in floating kitty window
kitty --class floating-bluetui \
  --title "Bluetooth Manager" \
  -o initial_window_width=800 \
  -o initial_window_height=600 \
  bluetui
