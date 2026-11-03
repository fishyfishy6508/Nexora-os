# Nexora OS 0.1.0 — Debian 13 Cybersecurity Edition

Nexora OS is a custom **Debian 13 (Trixie)** live image project with **XFCE**, black/red branding, Firefox ESR, Tor Browser Launcher, Wireshark, and defensive cybersecurity utilities.

## What this download is

This source archive does **not** contain an already-built `.iso`. It contains the scripts and configuration needed to build a real, bootable ISO. Generating an ISO requires Debian repositories, a Linux build environment, and several GB of disk space. Renaming a ZIP to `.iso` cannot make it bootable.

**Expected output once the build succeeds:**
`dist/NexoraOS-0.1.0-amd64.iso`

The ISO is configured for a 64-bit x86 PC, hybrid USB/DVD usage, legacy BIOS (Syslinux), and UEFI (GRUB EFI). Boot support is configured but **not tested here**.

## Easiest method on Windows 11 — use GitHub (no Linux installed on your computer)

1. Make a new **public GitHub repository**, such as `NexoraOS`.
2. Extract this ZIP to a folder.
3. Upload the extracted project files and folders to the new repository; preserve `.github/workflows/build-nexora-iso.yml` at that exact location.
   - Important: upload the **contents** of this extracted folder to the repository root, not the outer ZIP.
   - The GitHub browser uploader may not retain hidden folders depending on how files are selected; if the `.github` directory is missing, create `.github/workflows/build-nexora-iso.yml` using GitHub's "Create new file" option and paste in its contents.
4. Open your repo's **Actions** tab.
5. Pick **Build Nexora OS ISO**, then **Run workflow**.
6. If the workflow succeeds, open its run page and download **NexoraOS-0.1.0-amd64-ISO** from Artifacts.
7. GitHub usually wraps downloadable artifacts in a ZIP. Extract that ZIP and use the genuine `NexoraOS-0.1.0-amd64.iso` file inside it.

GitHub Actions is a build service; the ISO is assembled on the remote Linux runner. No Debian installation on your Windows PC is needed. Usage limits and file retention depend on GitHub's current terms and your account.

## Alternative: Windows 11 + Docker Desktop

Install Docker Desktop and start the Linux engine, extract the project and open PowerShell inside it:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build.ps1
```

This uses a Linux container under Windows and does not install Nexora onto your host computer. A build can fail if the Docker backend does not support the mounts required by live-build.

## Boot the resulting ISO

- **VirtualBox or VMware:** create a VM for Debian (64-bit), attach the ISO as a virtual optical drive, and boot.
- **Physical USB:** flash the ISO **as a disk image** to an appropriate USB stick (this erases that USB stick). Select the USB in your computer's BIOS/UEFI boot menu.
- **Installation:** start the live ISO and choose the Debian install option. Selecting a disk to install onto may overwrite its partitions/data. Test inside a VM before any hardware install.

## Included packages

- XFCE desktop, Firefox ESR, Tor Browser Launcher, Tor
- Wireshark, TShark, tcpdump, Nmap, WHOIS, DNS tools, traceroute, arp-scan, mtr
- ClamAV, Suricata, Fail2ban, UFW, Lynis, YARA, AIDE, auditd, AppArmor, Sleuth Kit
- Git, Python 3, OpenSSL, GnuPG and common desktop utilities

Tor Browser itself is fetched by Tor Browser Launcher on first start; it is not embedded into the ISO.

**This is not a security-audited distribution.** Use scanning and forensic tools only for your devices, training labs, and networks where you have explicit permission.

## Build checks

`build.sh` prints El Torito boot information to `dist/boot-report.txt` and writes a SHA-256 checksum, so boot entries can be inspected. This is **not equivalent to a successful BIOS/UEFI boot test**. In particular, Secure Boot support is not guaranteed. If a GitHub build fails, read the step's logs and correct the issue rather than using an incomplete image.

## References

- [Debian Live Manual](https://live-team.pages.debian.net/live-manual/html/live-manual.en.html)
- [Debian 13 live-build options](https://manpages.debian.org/trixie/live-build/lb_config.1.en.html)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
