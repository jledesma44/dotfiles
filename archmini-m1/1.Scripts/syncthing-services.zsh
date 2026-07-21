echo "######################################################################################"
echo "               ${YELLOW}!!  Enabling Syncthing Services !!${NC}                      "
echo "######################################################################################"

#Start syncthing services
if systemctl is-enabled --quiet syncthing@jledesma44.service && systemctl is-active --quiet syncthing@jledesma44.service; then
  echo "Syncthing service is already enabled and active, skipping."
else
  sudo systemctl enable --now syncthing@jledesma44.service
fi
