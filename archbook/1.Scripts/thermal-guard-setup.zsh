#Thermal safety net: emergency shutdown if CPU temp stays critical
echo "######################################################################################"
echo "               ${YELLOW}!!  Setting up thermal-guard safety net !!${NC}                      "
echo "######################################################################################"

THERMAL_GUARD_SCRIPT="/usr/local/bin/thermal-guard.sh"
THERMAL_GUARD_SERVICE="/etc/systemd/system/thermal-guard.service"

read -r -d '' THERMAL_GUARD_SCRIPT_CONTENT <<'SCRIPT_EOF'
#!/bin/bash
set -uo pipefail

WARNING_TEMP=85000   # millidegrees C
CRITICAL_TEMP=95000  # millidegrees C
POLL_INTERVAL=10
CRITICAL_CONSECUTIVE_REQUIRED=3
TARGET_USER="jledesma44"
TARGET_UID=1000

find_coretemp_package_file() {
  for hwmon in /sys/class/hwmon/hwmon*; do
    [[ "$(cat "$hwmon/name" 2>/dev/null)" == "coretemp" ]] || continue
    for label_file in "$hwmon"/temp*_label; do
      [[ -r "$label_file" ]] || continue
      if [[ "$(cat "$label_file")" == "Package id 0" ]]; then
        echo "${label_file%_label}_input"
        return 0
      fi
    done
  done
  return 1
}

notify_user() {
  local urgency="$1" title="$2" body="$3"
  sudo -u "$TARGET_USER" env XDG_RUNTIME_DIR="/run/user/$TARGET_UID" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$TARGET_UID/bus" \
    notify-send -u "$urgency" "$title" "$body" 2>/dev/null || true
}

TEMP_FILE=""
consecutive_critical=0
warned=0

while true; do
  if [[ -z "$TEMP_FILE" || ! -r "$TEMP_FILE" ]]; then
    TEMP_FILE=$(find_coretemp_package_file)
    if [[ -z "$TEMP_FILE" ]]; then
      logger -t thermal-guard "coretemp package sensor not found, retrying in ${POLL_INTERVAL}s"
      sleep "$POLL_INTERVAL"
      continue
    fi
    logger -t thermal-guard "monitoring $TEMP_FILE"
  fi

  raw_temp=$(cat "$TEMP_FILE" 2>/dev/null) || { sleep "$POLL_INTERVAL"; continue; }
  temp_c=$((raw_temp / 1000))

  if (( raw_temp >= CRITICAL_TEMP )); then
    consecutive_critical=$((consecutive_critical + 1))
    logger -t thermal-guard "CPU at ${temp_c}C (critical, reading ${consecutive_critical}/${CRITICAL_CONSECUTIVE_REQUIRED})"
    if (( consecutive_critical >= CRITICAL_CONSECUTIVE_REQUIRED )); then
      logger -t thermal-guard "CPU sustained at ${temp_c}C - initiating emergency shutdown"
      notify_user critical "THERMAL EMERGENCY" "CPU at ${temp_c}C - shutting down now to prevent damage"
      sleep 3
      systemctl poweroff
      exit 0
    fi
  else
    consecutive_critical=0
  fi

  if (( raw_temp >= WARNING_TEMP )); then
    if (( warned == 0 )); then
      logger -t thermal-guard "CPU at ${temp_c}C (warning)"
      notify_user normal "High CPU Temperature" "CPU at ${temp_c}C"
      warned=1
    fi
  else
    warned=0
  fi

  sleep "$POLL_INTERVAL"
done
SCRIPT_EOF

THERMAL_GUARD_SERVICE_CONTENT='[Unit]
Description=Thermal safety net - emergency shutdown if CPU temp stays critical
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/local/bin/thermal-guard.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target'

if sudo test -f "$THERMAL_GUARD_SCRIPT" && [[ "$(sudo cat "$THERMAL_GUARD_SCRIPT")" == "$THERMAL_GUARD_SCRIPT_CONTENT" ]] \
  && sudo test -f "$THERMAL_GUARD_SERVICE" && [[ "$(sudo cat "$THERMAL_GUARD_SERVICE")" == "$THERMAL_GUARD_SERVICE_CONTENT" ]]; then
  echo "thermal-guard already installed, skipping."
else
  TMP_SCRIPT=$(mktemp)
  TMP_SERVICE=$(mktemp)
  echo "$THERMAL_GUARD_SCRIPT_CONTENT" > "$TMP_SCRIPT"
  echo "$THERMAL_GUARD_SERVICE_CONTENT" > "$TMP_SERVICE"
  sudo install -m 0755 "$TMP_SCRIPT" "$THERMAL_GUARD_SCRIPT"
  sudo install -m 0644 "$TMP_SERVICE" "$THERMAL_GUARD_SERVICE"
  rm -f "$TMP_SCRIPT" "$TMP_SERVICE"
  sudo systemctl daemon-reload
  echo "Installed thermal-guard"
fi

if systemctl is-enabled --quiet thermal-guard 2>/dev/null && systemctl is-active --quiet thermal-guard; then
  echo "thermal-guard already enabled and active, skipping."
else
  sudo systemctl enable --now thermal-guard.service
fi
