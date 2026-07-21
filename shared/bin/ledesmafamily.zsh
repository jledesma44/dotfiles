#!/bin/zsh

# Function to display usage information
usage() {
  echo "Usage: $0 <ssid> <password>"
  echo "Connects to a Wi-Fi network using nmcli."
  exit 1
}

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  usage
fi

SSID="$1"
PASSWORD="$2"

echo "Attempting to connect to Wi-Fi network: $SSID"

# Connect to the Wi-Fi network
nmcli device wifi connect "$SSID" password "$PASSWORD"

# Check if the connection was successful
if [ $? -eq 0 ]; then
  echo "Successfully connected to $SSID."
  nmcli connection show --active
else
  echo "Failed to connect to $SSID. Please check the SSID and password."
  echo "You can view available networks with: nmcli device wifi list"
fi
