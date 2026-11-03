FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    xorriso \
    squashfs-tools \
    grub-pc-bin \
    grub-efi-amd64-bin \
    syslinux-common \
    isolinux \
    mtools \
    dosfstools \
    ca-certificates \
    debian-archive-keyring \
    rsync \
    cpio \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
CMD ["bash"]
