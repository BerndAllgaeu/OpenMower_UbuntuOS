#!/bin/bash
set -e

# OpenMower_UbuntuOS: Echtes Ubuntu-Image für Raspberry Pi bauen
# Voraussetzungen: kpartx, wget, xz, rsync, sudo, losetup, mount, chroot

# Konfiguration
UBUNTU_URL="https://cdimage.ubuntu.com/releases/noble/release/ubuntu-24.04.2-preinstalled-server-arm64+raspi.img.xz"
IMG_NAME="ubuntu-24.04.2-preinstalled-server-arm64+raspi.img"
IMG_XZ="ubuntu-24.04.2-preinstalled-server-arm64+raspi.img.xz"
OUTPUT_DIR="$(readlink -f $(dirname "$0")/../output)"
WORK_IMG="$OUTPUT_DIR/OpenMower_UbuntuOS.img"
SETUP_WEBUI_SRC="$(readlink -f $(dirname "$0")/../setup_webui)"

mkdir -p "$OUTPUT_DIR"

# 1. Download Ubuntu-Image, falls nicht vorhanden
if [ ! -f "$OUTPUT_DIR/$IMG_XZ" ]; then
  echo "[INFO] Lade Ubuntu-Image herunter..."
  wget -q --show-progress -O "$OUTPUT_DIR/$IMG_XZ" "$UBUNTU_URL" 2>&1 | grep -v '\.\{5\}'
fi

# 2. Entpacken (falls nötig)
if [ ! -f "$OUTPUT_DIR/$IMG_NAME" ]; then
  echo "[INFO] Entpacke Ubuntu-Image..."
  xz -dk "$OUTPUT_DIR/$IMG_XZ"
fi

# 3. Kopiere das Image als Arbeitskopie
cp -f "$OUTPUT_DIR/$IMG_NAME" "$WORK_IMG"

# 4. Partitionen einbinden
LOOPDEV=$(sudo losetup --show -fP "$WORK_IMG")
echo "[INFO] Loopdevice: $LOOPDEV"
sleep 2

# Mount rootfs (zweite Partition)
MNTDIR="$OUTPUT_DIR/mnt-rootfs"
mkdir -p "$MNTDIR"
sudo mount "${LOOPDEV}p2" "$MNTDIR"

# 5. Setup-WebUI und weitere Anpassungen per Ansible
ANSIBLE_SRC="$OUTPUT_DIR/ansible_src"
rm -rf "$ANSIBLE_SRC"
mkdir -p "$ANSIBLE_SRC"
rsync -a --exclude venv --exclude __pycache__ --exclude '*.pyc' "$SETUP_WEBUI_SRC/" "$ANSIBLE_SRC/setup_webui/"

sudo cp "$(dirname "$0")/ansible-playbook.yml" "$MNTDIR/root/ansible-playbook.yml"
sudo cp -r "$ANSIBLE_SRC" "$MNTDIR/ansible_src"

sudo chroot "$MNTDIR" bash -c "apt-get update && apt-get install -y ansible && ansible-playbook /root/ansible-playbook.yml"

# 6. Unmount und aufräumen
sudo umount "$MNTDIR"
sudo losetup -d "$LOOPDEV"
rm -rf "$MNTDIR"

# 7. Komprimieren
xz -z -f "$WORK_IMG"

ls -lh "$OUTPUT_DIR"
echo "[INFO] Build abgeschlossen. Image liegt in $OUTPUT_DIR/OpenMower_UbuntuOS.img.xz"
