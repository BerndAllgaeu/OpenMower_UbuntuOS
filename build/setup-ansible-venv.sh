#!/bin/bash
# Erstellt ein venv für Ansible und installiert benötigte Pakete (Ansible, Podman SDK)
# Usage: ./setup-ansible-venv.sh
set -e

VENV_DIR="/home/ubuntu/venv_ansible"
PYTHON=python3

if [ ! -d "$VENV_DIR" ]; then
    $PYTHON -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

pip install --upgrade pip
pip install ansible
pip install podman podman-compose
ansible-galaxy collection install containers.podman

echo "Ansible venv bereit unter $VENV_DIR."
