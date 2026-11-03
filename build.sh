#!/usr/bin/env bash
set -Eeuo pipefail

cd /work
mkdir -p /work/dist
rm -rf /work/build
mkdir -p /work/build/config

# Copy curated customization files into a clean isolated build directory.
cp -a /work/config/. /work/build/config/
cd /work/build

echo "NEXORA OS 0.1.0 — Debian 13 (Trixie), XFCE, 64-bit"
echo "Creating the ISO build configuration..."

lb config \
    --distribution trixie \
    --architecture amd64 \
    --binary-image iso-hybrid \
    --bootloaders "syslinux grub-efi" \
    --debian-installer live \
    --debian-installer-gui true \
    --archive-areas "main contrib non-free-firmware" \
    --firmware-chroot true \
    --firmware-binary true \
    --debconf-frontend noninteractive \
    --apt-recommends true \
    --checksums sha256 \
    --image-name nexora \
    --iso-application "Nexora OS 0.1.0" \
    --iso-publisher "Nexora OS Project" \
    --iso-volume "NEXORA_010" \
    --bootappend-live "boot=live components username=nexora hostname=nexora"

echo "Downloading Debian packages and constructing live filesystem..."
lb build

shopt -s nullglob
images=(*.hybrid.iso *.iso)
if (( ${#images[@]} == 0 )); then
    echo "ERROR: live-build finished without creating an ISO" >&2
    exit 1
fi

cp -- "${images[0]}" /work/dist/NexoraOS-0.1.0-amd64.iso
echo "Created /work/dist/NexoraOS-0.1.0-amd64.iso"
sha256sum /work/dist/NexoraOS-0.1.0-amd64.iso \
    > /work/dist/NexoraOS-0.1.0-amd64.iso.sha256

# Inspect boot entries. Do not claim a successful boot without an actual VM test.
echo ""
echo "Boot image information:"
xorriso -indev /work/dist/NexoraOS-0.1.0-amd64.iso \
    -report_el_torito plain 2>&1 | tee /work/dist/boot-report.txt

echo "Finished."
