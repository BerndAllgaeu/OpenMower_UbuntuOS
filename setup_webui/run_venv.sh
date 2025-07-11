#!/bin/bash
# Erstellt und aktiviert das zentrale venv, installiert Abhängigkeiten und startet die Flask-App
set -e
cd "$(dirname "$0")"
if [ ! -d /home/ubuntu/venv_webui ]; then
  python3 -m venv /home/ubuntu/venv_webui
fi
source /home/ubuntu/venv_webui/bin/activate
pip install -r requirements.txt
python app.py
