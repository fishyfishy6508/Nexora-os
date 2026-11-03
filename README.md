# Nexora OS 0.1.0 Beta

**Made for Ethical Hacking** — Debian 13 based · XFCE · 64-bit · black and red.

This repository creates a **real hybrid BIOS/UEFI bootable ISO**. Use it with VirtualBox/VMware, or flash it onto a USB stick. The operating system is installed from boot media, *not* as a Windows application.

## Start fresh on GitHub (no Linux installation required on Windows 11)

1. Make a new GitHub repository named `Nexora-os`. Do **not** choose GitHub's automatic README/License/.gitignore options (this kit includes its own README).
2. Download `NexoraOS-0.1.0-Beta-GitHub.zip`, right-click **Extract All**, and open the extracted files.
3. On the GitHub repository, choose **Add file → Upload files**. Upload the **contents** of the extracted folder (not the outer folder). You should see `Dockerfile`, `build.sh`, `README.md`, `config/`, `docs/` at repository root.
4. GitHub's browser uploader sometimes omits hidden folders. The workflow MUST exist at `.github/workflows/build-nexora-iso.yml`. If it is missing, use **Add file → Create new file**, type that full path, and paste the YAML contents from this kit. **Commit changes**.
5. Open GitHub **Actions → Build Nexora OS 0.1.0 Beta ISO → Run workflow**. It downloads Debian 13 packages, builds the ISO, verifies the checksum, and checks BIOS and UEFI boot entries.
6. When the run is green, open the run **Summary**. Scroll to **Artifacts**, click `NexoraOS-0.1.0-amd64-ISO`. GitHub downloads a ZIP wrapper; extract that ZIP.
7. Inside is **`NexoraOS-0.1.0-amd64.iso`**, the bootable operating-system image. Do *not* rename the source ZIP to `.iso`.

**Note:** Large ISO builds can take significant time and disk space. Hosted build and artifact size quotas are controlled by GitHub. The build requires internet and a Linux image-builder (provided by GitHub Actions). This repo is source code, **not a prebuilt ISO**.

## ISO contents

- Nexora OS 0.1.0 Beta, XFCE, custom background, red/black login theme and custom icon theme (including trash, drives, and file manager icons)
- Plymouth splash: **“Booting into Nexora.”**
- Calamares graphical installer with Nexora logo and three-slide installation-progress slideshow
- Welcome to Nexora popup on first login: **“Made for Ethical Hacking”**
- Nexora Security Toolbox: one-click network and defensive-analysis program launcher
- Firefox ESR, Tor Browser Launcher, Wireshark, TShark, tcpdump, Nmap, arp-scan, traceroute, DNS utilities, iperf3
- Lynis, ClamAV, Suricata, UFW, Fail2ban, AIDE, auditd, AppArmor, YARA, Sleuth Kit, plus Python and developer utilities
- Security updates from the underlying **Debian 13 repositories**, with unattended-upgrades enabled. Updates still depend on vendor support and a working internet connection.

**Tor Browser:** The Tor Browser *launcher* is included. The browser bundle itself is downloaded separately on first use and needs internet access.

**Ethical use:** Only test systems and networks that you own or have explicit authorization to assess. Security tools are not inherently a guarantee of safety.

## VM test checklist before installing on a real PC

- Create a Debian 64-bit VM with **4 GB RAM**, **2 CPU cores**, and at least **30 GB** storage (estimated for beta testing).
- Mount the `.iso` as a virtual optical disc. Try with **EFI disabled** (legacy BIOS) and again with **EFI enabled**.
- Boot **Nexora Live** and confirm that wallpaper, logo, trash icons, XFCE About/System, and welcome screen display your branding.
- Open Security Toolbox, Firefox ESR, and Wireshark. Tor Browser needs internet on first use.
- Take a VM snapshot, then test **Install Nexora OS** from the live desktop in a **disposable VM only**. Installer partitioning can erase target disks.
- Reboot the installed VM without the ISO and test system updates and boot splash again.

## Branding scope

Nexora uses its own user-facing OS identity, login, splash, installer branding, wallpaper, XFCE icons, and application launchers. A Debian-based system **still contains Debian-named packages, APT sources, copyright notices and technical files**, and some upstream program Help/About screens may show their own authors or projects. The files are not erased or falsified because that would break security updates, attribution, or package management. Test the final ISO for any remaining visible branding you want to adjust.

## Optional custom download landing page

Open `docs/index.html` locally or enable **Settings → Pages → Deploy from branch → main /docs** on your GitHub repository. The page explains where to obtain the current ISO artifact. The GitHub Actions Artifacts download UI itself cannot be customized by this HTML page.

## Optional local Windows 11 build

If you have Docker Desktop installed and running:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build.ps1
```

Docker needs privileged filesystem operations; a full Linux VM may be needed if Docker Desktop cannot provide them. GitHub Actions is the recommended path.

## Verification

The GitHub workflow validates Python syntax, builds in Debian 13, runs `xorriso -report_el_torito plain`, **requires both BIOS and UEFI boot entries**, and verifies SHA256 using a **read-only checksum check**. This avoids the root-owned file permission failure from the previous version of the build scripts. However, **static checks and a green ISO build do not guarantee the VM boots or the installer works**. Do the checklist above before deploying to real hardware.

## References

- https://live-team.pages.debian.net/live-manual/html/live-manual.en.html
- https://manpages.debian.org/trixie/live-build/lb_config.1.en.html
- https://calamares.codeberg.page/docs/deploy-configuration/
- https://docs.github.com/en/actions/how-tos/manage-workflow-runs/download-workflow-artifacts
