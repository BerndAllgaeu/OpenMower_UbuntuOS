#!/bin/bash
set -euo pipefail

# OpenMower_UbuntuOS: Remote-Installer für das First-Boot-Setup via SSH
# Fragt Username, Passwort und IP ab, führt das Setup-Skript remote aus und zeigt den WebUI-Link an.

read -rp "Raspberry Pi IP-Adresse: " PI_IP
read -rp "SSH-Benutzername: " PI_USER
read -rsp "SSH-Passwort: " PI_PASS; echo

REMOTE_SCRIPT_PATH="/tmp/openmower-setup.sh"
LOCAL_SCRIPT_PATH="$(dirname "$0")/build-image.sh"

# Kopiere das Setup-Skript auf den Pi
sshpass -p "$PI_PASS" scp -o StrictHostKeyChecking=no "$LOCAL_SCRIPT_PATH" "$PI_USER@$PI_IP:$REMOTE_SCRIPT_PATH"

# Führe das Setup-Skript remote aus
sshpass -p "$PI_PASS" ssh -o StrictHostKeyChecking=no "$PI_USER@$PI_IP" "bash $REMOTE_SCRIPT_PATH"

# Ermittle die IP-Adresse für den WebUI-Link (ggf. anpassen, falls Port oder Pfad anders)
WEBUI_URL="http://$PI_IP:5000/"

echo "[INFO] Setup abgeschlossen. Die WebUI ist erreichbar unter: $WEBUI_URL"
