#!/usr/bin/zsh

CARD="alsa_card.pci-0000_00_1f.3"
HDMI_PROFILE="output:hdmi-stereo+input:analog-stereo"
ANALOG_PROFILE="output:analog-stereo+input:analog-stereo"
HDMI_SINK="alsa_output.pci-0000_00_1f.3.hdmi-stereo"
ANALOG_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"

current=$(pactl list cards | grep "Active Profile" | head -1 | awk '{print $3}')

if [[ "$current" == "$HDMI_PROFILE" ]]; then
  pactl set-card-profile "$CARD" "$ANALOG_PROFILE"
  pactl set-default-sink "$ANALOG_SINK"
  notify-send -i audio-headphones "Audio" "Switched to MacBook analog"
else
  pactl set-card-profile "$CARD" "$HDMI_PROFILE"
  pactl set-default-sink "$HDMI_SINK"
  notify-send -i audio-headphones "Audio" "Switched to Kuycan display 3.5mm jack"
fi

pkill -SIGRTMIN+9 waybar
