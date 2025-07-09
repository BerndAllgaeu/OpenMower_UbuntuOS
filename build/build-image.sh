#!/bin/bash
set -euxo pipefail

# OpenMower_UbuntuOS: Setup-Skript für Raspberry Pi (ausführen nach erstem Boot)
# Dieses Skript installiert Ansible, klont das Setup-Repo und führt das Playbook lokal aus.

REPO_URL="https://github.com/BerndAllgaeu/OpenMower_UbuntuOS.git"  # <-- Hier anpassen!
PLAYBOOK="build/playbook.yml"  # Name des Playbooks im Repo
REPO_DIR="OpenMower_UbuntuOS-setup"  # Zielverzeichnis für das geklonte Repo

# 1. Ansible & Git installieren (falls nicht vorhanden)
sudo apt-get update
sudo apt-get install -y ansible git

# 2. Repo klonen (ggf. vorher löschen)
rm -rf "$REPO_DIR"
git clone "$REPO_URL" "$REPO_DIR"
cd "$REPO_DIR"

# Locale-Workaround für Ansible
export LC_ALL=C.UTF-8

# 3. Playbook lokal ausführen
ansible-playbook -i "localhost," -c local "$PLAYBOOK"

echo "[INFO] Setup abgeschlossen. System ist bereit."
