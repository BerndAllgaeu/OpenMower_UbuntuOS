#!/bin/bash
# Installiert Python, venv und das Setup-WebUI auf einem Ubuntu-System
set -e

# Installiere Systemabhängigkeiten
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip git

# Zielverzeichnis für das WebUI
TARGET_DIR="/opt/openmower/setup_webui"
sudo mkdir -p "$TARGET_DIR"
sudo rsync -a --exclude venv --exclude __pycache__ --exclude '*.pyc' "$(dirname "$0")/../setup_webui/" "$TARGET_DIR/"

# venv anlegen und Abhängigkeiten installieren
cd "$TARGET_DIR"
sudo python3 -m venv venv
sudo chown -R $USER:$USER venv
source venv/bin/activate
pip install -r requirements.txt

# Systemd-Service für Autostart anlegen
SERVICE_FILE="/etc/systemd/system/openmower-setup-webui.service"
echo "[Unit]
Description=OpenMower Setup WebUI
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$TARGET_DIR
ExecStart=$TARGET_DIR/venv/bin/python app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee "$SERVICE_FILE"

sudo systemctl daemon-reload
sudo systemctl enable openmower-setup-webui.service
sudo systemctl restart openmower-setup-webui.service

echo "[INFO] Setup-WebUI läuft jetzt als Service. Zugriff: http://<raspi-ip>:5000"
