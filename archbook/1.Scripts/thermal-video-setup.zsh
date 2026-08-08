#Hardware video decode (VA-API) + thermal management setup
echo "######################################################################################"
echo "               ${YELLOW}!!  Setting up thermal + hardware video decode !!${NC}                      "
echo "######################################################################################"

# thermald: proactive thermal management for this fanless Kaby Lake-Y chip
if systemctl is-enabled --quiet thermald 2>/dev/null && systemctl is-active --quiet thermald; then
  echo "thermald already enabled and active, skipping."
else
  sudo pacman -S --needed --noconfirm thermald
  sudo systemctl enable --now thermald
fi

# VA-API hardware video decode: reduces CPU/heat during video playback by offloading
# decode to the GPU instead of software-decoding on the CPU.
VAAPI_PREFS='// Force VA-API hardware video decode (Intel iHD driver) to reduce CPU/heat during video playback
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("widget.dmabuf.force-enabled", true);'

install_vaapi_prefs() {
  local profile_dir="$1"
  if [[ ! -d "$profile_dir" ]]; then
    return
  elif [[ -f "$profile_dir/user.js" ]] && grep -q "media.ffmpeg.vaapi.enabled" "$profile_dir/user.js"; then
    echo "VA-API prefs already present in $profile_dir, skipping."
  else
    echo "$VAAPI_PREFS" >> "$profile_dir/user.js"
    echo "Added VA-API prefs to $profile_dir/user.js"
  fi
}

# Firefox: profiles.ini may define multiple installs (e.g. regular + Developer Edition),
# each with its own default profile under an [InstallXXXX] section.
if [[ -f "$HOME/.config/mozilla/firefox/profiles.ini" ]]; then
  while IFS= read -r profile_path; do
    install_vaapi_prefs "$HOME/.config/mozilla/firefox/$profile_path"
  done < <(awk '/^\[Install/{install=1} /^\[Profile/{install=0} install && /^Default=/{sub(/^Default=/,""); print}' "$HOME/.config/mozilla/firefox/profiles.ini")
fi

# LibreWolf
if [[ -f "$HOME/.config/librewolf/librewolf/installs.ini" ]]; then
  while IFS= read -r profile_path; do
    install_vaapi_prefs "$HOME/.config/librewolf/librewolf/$profile_path"
  done < <(grep "^Default=" "$HOME/.config/librewolf/librewolf/installs.ini" | sed 's/^Default=//')
fi
