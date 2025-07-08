#!/bin/bash
set -e

# OpenMower_UbuntuOS Image Build Script
# Platzhalter: Ubuntu-Image für Raspberry Pi vorbereiten und Setup-WebUI installieren

# --- Beispiel: Ubuntu-Server-Image mounten und chrooten (Pseudo-Code) ---
# 1. Image vorbereiten (z.B. mit pi-gen, ubuntu-image, oder manuell)
# 2. Partition mounten
# 3. chroot ins Image und install_setup_webui.sh ausführen
#
# Hier als Demo: Installation auf dem aktuellen System (für CI-Test)

bash $(dirname "$0")/install_setup_webui.sh

# Dummy-Image erzeugen (für CI-Demo)
mkdir -p ../output
IMG=../output/OpenMower_UbuntuOS.img
XZ=../output/OpenMower_UbuntuOS.img.xz
dd if=/dev/zero of="$IMG" bs=1M count=10
xz -z -f "$IMG"

ls -lh ../output

echo "[INFO] Build-Logik für echtes Image folgt!"
exit 0
