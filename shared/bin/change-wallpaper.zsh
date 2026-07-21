#!/usr/bin/zsh

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

if [[ -n "$1" ]]; then
    selected="$1"
else
    selected=$(ls "$WALLPAPER_DIR" | rofi -dmenu -p "Wallpaper" -i)
    [[ -z "$selected" ]] && exit 0
    selected="$WALLPAPER_DIR/$selected"
fi

matugen image --prefer darkness "$selected"
