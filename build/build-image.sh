#!/bin/bash
set -e

# OpenMower_UbuntuOS: Echtes Ubuntu-Image für Raspberry Pi bauen
# Voraussetzungen: kpartx, wget, xz, rsync, sudo, losetup, mount, chroot

# Konfiguration
UBUNTU_URL="https://cdimage.ubuntu.com/releases/noble/release/ubuntu-24.04.2-preinstalled-server-arm64+raspi.img.xz"
IMG_NAME="ubuntu-24.04.2-preinstalled-server-arm64+raspi.img"
IMG_XZ="ubuntu-24.04.2-preinstalled-server-arm64+raspi.img.xz"
OUTPUT_DIR="$(dirname "$0")/../output"
WORK_IMG="$OUTPUT_DIR/OpenMower_UbuntuOS.img"

mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

# 1. Download Ubuntu-Image, falls nicht vorhanden
if [ ! -f "$IMG_XZ" ]; then
  echo "[INFO] Lade Ubuntu-Image herunter..."
  wget "$UBUNTU_URL"
fi

# 2. Entpacken (falls nötig)
if [ ! -f "$IMG_NAME" ]; then
  echo "[INFO] Entpacke Ubuntu-Image..."
  xz -dk "$IMG_XZ"
fi

# 3. Kopiere das Image als Arbeitskopie
cp -f "$IMG_NAME" "$WORK_IMG"

# 4. Partitionen einbinden
LOOPDEV=$(sudo losetup --show -fP "$WORK_IMG")
echo "[INFO] Loopdevice: $LOOPDEV"

# Warte kurz, bis Partitionen erkannt werden
sleep 2

# Mount rootfs (zweite Partition)
MNTDIR="mnt-rootfs"
mkdir -p "$MNTDIR"
sudo mount "${LOOPDEV}p2" "$MNTDIR"

# 5. Setup-WebUI ins Image kopieren
sudo rsync -a --exclude venv --exclude __pycache__ --exclude '*.pyc' "$(dirname "$0")/../setup_webui/" "$MNTDIR/opt/openmower/setup_webui/"

# 6. (Optional) Weitere Anpassungen, z.B. systemd-Service, Konfigurationsdateien
# ...hier können weitere Anpassungen folgen...

# 7. Unmount und aufräumen
sudo umount "$MNTDIR"
sudo losetup -d "$LOOPDEV"
rm -rf "$MNTDIR"

# 8. Komprimieren
xz -z -f "$WORK_IMG"

ls -lh "$OUTPUT_DIR"
echo "[INFO] Build abgeschlossen. Image liegt in $OUTPUT_DIR/OpenMower_UbuntuOS.img.xz"
exit 0
