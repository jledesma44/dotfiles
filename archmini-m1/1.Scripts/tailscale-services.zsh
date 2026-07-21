#Enabling Tailscale servcies
echo "######################################################################################"
echo "               ${YELLOW}!!  Enabling Tailscale Services !!${NC}                      "
echo "######################################################################################"
#Start Tailscaled
if systemctl is-enabled --quiet tailscaled && systemctl is-active --quiet tailscaled; then
  echo "tailscaled is already enabled and active, skipping."
else
  sudo systemctl enable --now tailscaled
fi

#Set login
if [[ "$(tailscale status --json | jq -r '.BackendState')" == "Running" ]]; then
  echo "Tailscale is already up, skipping login."
else
  sudo tailscale up --ssh
fi

