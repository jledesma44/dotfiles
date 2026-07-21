#!/bin/zsh

echo "=== Wi-Fi Connect ==="
echo

# Prompt for SSID
read "SSID?Enter Wi-Fi network name (SSID): "

# Check if SSID is empty
if [ -z "$SSID" ]; then
  echo "Error: SSID cannot be empty."
  exit 1
fi

# Prompt for password (with hidden input)
read -s "PASSWORD?Enter Wi-Fi password: "
echo # New line after hidden input

# Check if password is empty
if [ -z "$PASSWORD" ]; then
  echo "Error: Password cannot be empty."
  exit 1
fi

echo
echo "Attempting to connect to Wi-Fi network: $SSID"

# First, try to connect with explicit WPA-PSK security (most common for home networks)
nmcli device wifi connect "$SSID" password "$PASSWORD" --ask 2>/dev/null

# If that fails, try the original command
if [ $? -ne 0 ]; then
  nmcli connection add type wifi con-name "$SSID" ifname wlp2s0 ssid "$SSID" \
    wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$PASSWORD"

  if [ $? -eq 0 ]; then
    nmcli connection up "$SSID"
  fi
fi

# Check if the connection was successful
if nmcli connection show --active | grep -q "$SSID"; then
  echo "Successfully connected to $SSID."
  nmcli connection show --active
else
  echo "Failed to connect to $SSID. Please check the SSID and password."
  echo "You can view available networks with: nmcli device wifi list"
fi
