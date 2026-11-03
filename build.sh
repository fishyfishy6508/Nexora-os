#!/usr/bin/env bash
set -Eeuo pipefail
umask 022
cd /work
mkdir -p dist
rm -rf /work/build
mkdir -p /work/build/config
cp -a /work/config/. /work/build/config/
cd /work/build

echo '== Nexora OS 0.1.0 Beta | Debian 13 base | XFCE | x86_64 =='
echo 'Step 1: Generate hybrid ISO build configuration'
lb config \
  --distribution trixie \
  --architecture amd64 \
  --binary-image iso-hybrid \
  --bootloaders 'syslinux grub-efi' \
  --debian-installer none \
  --archive-areas 'main contrib non-free-firmware' \
  --firmware-chroot true \
  --firmware-binary true \
  --apt-recommends true \
  --checksums sha256 \
  --image-name nexora \
  --iso-application 'Nexora OS 0.1.0 Beta' \
  --iso-publisher 'Nexora OS Project' \
  --iso-volume 'NEXORA_010' \
  --bootappend-live 'boot=live components username=nexora hostname=nexora quiet splash'

echo 'Step 2: Build filesystem and ISO (downloads packages from official mirrors)'
lb build

# This is a build, never a file-extension conversion.
shopt -s nullglob
images=(./*.hybrid.iso ./*.iso)
if (( ${#images[@]} < 1 )); then
  echo 'ERROR: live-build did not output an ISO.' >&2
  exit 2
fi
src="${images[0]}"
dest='/work/dist/NexoraOS-0.1.0-amd64.iso'
cp -- "$src" "$dest"
chmod a+r "$dest"

echo 'Step 3: Validate ISO catalog'
xorriso -indev "$dest" -report_el_torito plain \
  > /work/dist/boot-report.txt 2>&1
# Fail clearly rather than upload an unbootable image.
if ! grep -Eq 'El Torito boot img.*BIOS' /work/dist/boot-report.txt; then
  echo 'ERROR: BIOS boot entry missing. Read dist/boot-report.txt' >&2
  cat /work/dist/boot-report.txt >&2
  exit 3
fi
if ! grep -Eq 'El Torito boot img.*UEFI' /work/dist/boot-report.txt; then
  echo 'ERROR: UEFI boot entry missing. Read dist/boot-report.txt' >&2
  cat /work/dist/boot-report.txt >&2
  exit 4
fi
xorriso -indev "$dest" -report_system_area plain \
  > /work/dist/system-area-report.txt 2>&1

# Write a relative checksum that can be verified inside or outside Docker.
(cd /work/dist && sha256sum NexoraOS-0.1.0-amd64.iso > NexoraOS-0.1.0-amd64.iso.sha256)
chmod -R a+r /work/dist
(cd /work/dist && sha256sum -c NexoraOS-0.1.0-amd64.iso.sha256)
ls -lh "$dest"
echo 'SUCCESS: Nexora ISO created. BIOS/UEFI catalog entries verified; boot in a VM to test.'
