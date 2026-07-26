#Ventoy passwordless launch + dark theme setup
echo "######################################################################################"
echo "               ${YELLOW}!!  Setting up Ventoy launcher !!${NC}                      "
echo "######################################################################################"

# Scoped NOPASSWD rule: only /usr/bin/ventoygui, only this user, preserves display/theme env
SUDOERS_FILE="/etc/sudoers.d/ventoy"
SUDOERS_CONTENT='Defaults:jledesma44 env_keep += "DISPLAY XAUTHORITY WAYLAND_DISPLAY GTK_THEME"
jledesma44 ALL=(root) NOPASSWD: /usr/bin/ventoygui'

if sudo test -f "$SUDOERS_FILE" && [[ "$(sudo cat "$SUDOERS_FILE")" == "$SUDOERS_CONTENT" ]]; then
  echo "Ventoy sudoers rule already in place, skipping."
else
  TMP_SUDOERS=$(mktemp)
  echo "$SUDOERS_CONTENT" > "$TMP_SUDOERS"
  if sudo visudo -cf "$TMP_SUDOERS"; then
    sudo install -m 0440 -o root -g root "$TMP_SUDOERS" "$SUDOERS_FILE"
    echo "Installed $SUDOERS_FILE"
  else
    echo "Refusing to install invalid sudoers file"
  fi
  rm -f "$TMP_SUDOERS"
fi

# Root needs the theme discoverable outside the user's own $HOME
THEME_LINK="/usr/share/themes/Graphite-Dark"
if [[ -e "$THEME_LINK" ]]; then
  echo "Graphite-Dark already linked system-wide, skipping."
else
  sudo ln -s "$HOME/.themes/Graphite-Dark" "$THEME_LINK"
  echo "Linked Graphite-Dark into $THEME_LINK"
fi
