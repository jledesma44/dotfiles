#!/usr/bin/zsh

# Script to open/toggle gazelle in a floating kitty window on Hyprland

# Toggle: if already open, close it
if hyprctl clients -j | grep -q '"class": "wifi-tui"'; then
  hyprctl dispatch closewindow class:wifi-tui
  exit 0
fi

# Check if kitty is installed
if ! command -v kitty &>/dev/null; then
  echo "kitty is not installed!"
  exit 1
fi

# Check if gazelle is installed
if ! command -v gazelle &>/dev/null; then
  echo "gazelle is not installed!"
  echo "Install it with: yay -S gazelle-tui"
  exit 1
fi

# Launch Wifi manager in floating kitty window
kitty --class wifi-tui \
  --title "Wifi Manager" \
  -o initial_window_width=1400 \
  -o initial_window_height=800 \
  gazelle
