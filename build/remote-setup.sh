#!/bin/bash
set -euo pipefail

# OpenMower_UbuntuOS: Remote-Installer für das First-Boot-Setup via SSH
# Unterstützt jetzt auch SSH-Key-Authentifizierung.

CONFIG_FILE="$(dirname "$0")/remote-setup.conf"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_rsa}"

if [ -f "$CONFIG_FILE" ]; then
  # Konfigurationsdatei einlesen
  source "$CONFIG_FILE"
  echo "[INFO] Verwende gespeicherte Zugangsdaten: $PI_USER@$PI_IP"
else
  read -rp "Raspberry Pi IP-Adresse: " PI_IP
  read -rp "SSH-Benutzername: " PI_USER
  read -rsp "SSH-Passwort (Enter für Key-Login): " PI_PASS; echo
  # Zugangsdaten speichern
  echo "PI_IP=\"$PI_IP\"" > "$CONFIG_FILE"
  echo "PI_USER=\"$PI_USER\"" >> "$CONFIG_FILE"
  echo "PI_PASS=\"$PI_PASS\"" >> "$CONFIG_FILE"
  chmod 600 "$CONFIG_FILE"
fi

REMOTE_SCRIPT_PATH="/tmp/openmower-setup.sh"
LOCAL_SCRIPT_PATH="$(dirname "$0")/build-image.sh"

if [ -z "${PI_PASS:-}" ]; then
  # SSH-Key-Authentifizierung
  echo "[INFO] Versuche Verbindung mit SSH-Key ($SSH_KEY) ..."
  scp -i "$SSH_KEY" -o StrictHostKeyChecking=no "$LOCAL_SCRIPT_PATH" "$PI_USER@$PI_IP:$REMOTE_SCRIPT_PATH"
  ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$PI_USER@$PI_IP" "bash $REMOTE_SCRIPT_PATH"
else
  # Passwort-Authentifizierung
  echo "[INFO] Setze passwortloses sudo für $PI_USER auf dem Pi ..."
  sshpass -p "$PI_PASS" ssh -o StrictHostKeyChecking=no "$PI_USER@$PI_IP" \
    "echo '$PI_PASS' | sudo -S bash -c 'echo \"$PI_USER ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/$PI_USER && chmod 440 /etc/sudoers.d/$PI_USER'"
  sshpass -p "$PI_PASS" scp -o StrictHostKeyChecking=no "$LOCAL_SCRIPT_PATH" "$PI_USER@$PI_IP:$REMOTE_SCRIPT_PATH"
  sshpass -p "$PI_PASS" ssh -o StrictHostKeyChecking=no "$PI_USER@$PI_IP" "bash $REMOTE_SCRIPT_PATH"
fi

WEBUI_URL="http://$PI_IP:5000/"
echo "[INFO] Setup abgeschlossen. Die WebUI ist erreichbar unter: $WEBUI_URL"
