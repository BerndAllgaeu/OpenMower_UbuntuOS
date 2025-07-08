#!/bin/bash
# Erstellt und aktiviert ein venv, installiert Abhängigkeiten und startet die Flask-App
set -e
cd "$(dirname "$0")"
if [ ! -d venv ]; then
  python3 -m venv venv
fi
source venv/bin/activate
pip install -r requirements.txt
python app.py
