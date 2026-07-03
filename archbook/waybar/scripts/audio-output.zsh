#!/usr/bin/zsh

default_sink=$(pactl get-default-sink 2>/dev/null)

case "$default_sink" in
*hdmi*)
  echo '{"text": "󰋋 Monitor", "tooltip": "Monitor 3.5mm jack", "class": "monitor"}'
  ;;
*bluez*)
  name=$(pactl list sinks 2>/dev/null | grep -A 5 "Name: $default_sink" | grep "Description:" | cut -d: -f2- | xargs)
  echo "{\"text\": \"󰂯 ${name:-Bluetooth}\", \"tooltip\": \"Bluetooth: ${name:-unknown}\", \"class\": \"bluetooth\"}"
  ;;
*analog*)
  echo '{"text": "󰕾 MacBook", "tooltip": "MacBook built-in audio", "class": "analog"}'
  ;;
*)
  echo '{"text": "󰕾 Audio", "tooltip": "'"$default_sink"'", "class": "unknown"}'
  ;;
esac
