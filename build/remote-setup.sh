#!/bin/bash
set -euo pipefail

# OpenMower_UbuntuOS: Remote-Installer für das First-Boot-Setup via SSH
# Speichert IP, User und Passwort lokal für Folgeaufrufe.

CONFIG_FILE="$(dirname "$0")/remote-setup.conf"

if [ -f "$CONFIG_FILE" ]; then
  # Konfigurationsdatei einlesen
  source "$CONFIG_FILE"
  echo "[INFO] Verwende gespeicherte Zugangsdaten: $PI_USER@$PI_IP"
else
  read -rp "Raspberry Pi IP-Adresse: " PI_IP
  read -rp "SSH-Benutzername: " PI_USER
  read -rsp "SSH-Passwort: " PI_PASS; echo
  # Zugangsdaten speichern
  echo "PI_IP=\"$PI_IP\"" > "$CONFIG_FILE"
  echo "PI_USER=\"$PI_USER\"" >> "$CONFIG_FILE"
  echo "PI_PASS=\"$PI_PASS\"" >> "$CONFIG_FILE"
  chmod 600 "$CONFIG_FILE"
fi

REMOTE_SCRIPT_PATH="/tmp/openmower-setup.sh"
LOCAL_SCRIPT_PATH="$(dirname "$0")/build-image.sh"

# Kopiere das Setup-Skript auf den Pi
sshpass -p "$PI_PASS" scp -o StrictHostKeyChecking=no "$LOCAL_SCRIPT_PATH" "$PI_USER@$PI_IP:$REMOTE_SCRIPT_PATH"

# Führe das Setup-Skript remote aus
sshpass -p "$PI_PASS" ssh -o StrictHostKeyChecking=no "$PI_USER@$PI_IP" "bash $REMOTE_SCRIPT_PATH"

WEBUI_URL="http://$PI_IP:5000/"
echo "[INFO] Setup abgeschlossen. Die WebUI ist erreichbar unter: $WEBUI_URL"
