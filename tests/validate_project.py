#!/usr/bin/env python3
"""Static sanity checks; not a substitute for building and boot-testing the ISO."""
from pathlib import Path
import ast
import configparser
import sys
import xml.etree.ElementTree as ET
import struct

root = Path(__file__).resolve().parents[1]
base = root / 'config/includes.chroot'
required = [
    root / 'Dockerfile', root / 'build.sh', root / '.github/workflows/build-nexora-iso.yml',
    root / 'config/package-lists/nexora-desktop.list.chroot',
    root / 'config/package-lists/nexora-security.list.chroot',
    base / 'usr/local/share/nexora/welcome.py',
    base / 'usr/local/share/nexora/toolbox.py',
    base / 'usr/share/plymouth/themes/nexora/nexora.script',
    base / 'usr/share/plymouth/themes/nexora/booting.png',
    base / 'etc/calamares/branding/nexora/branding.desc',
    base / 'usr/share/backgrounds/nexora/nexora-wallpaper.png',
    root / 'config/bootloaders/syslinux_common/splash.png',
    root / 'config/bootloaders/grub-pc/splash.png',
]
for path in required:
    assert path.is_file() and path.stat().st_size > 0, f'Missing/empty: {path.relative_to(root)}'
for path in (base / 'usr/local/share/nexora').glob('*.py'):
    ast.parse(path.read_text(), filename=str(path))
for path in (base / 'etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml').glob('*.xml'):
    ET.parse(path)
for path in root.rglob('*.png'):
    data=path.read_bytes()
    assert data[:8] == b'\x89PNG\r\n\x1a\n', f'Invalid PNG: {path}'
    w,h=struct.unpack('>II',data[16:24])
    assert w>0 and h>0
for path in root.rglob('*.desktop'):
    obj = configparser.ConfigParser(interpolation=None)
    obj.optionxform = str
    obj.read(path)
    assert 'Desktop Entry' in obj, f'Malformed desktop entry: {path}'
assert '0.1.0' in (root/'README.md').read_text()
assert 'branding: nexora' in (root/'config/hooks/live/0900-nexora-branding.hook.chroot').read_text()
print('Nexora OS 0.1.0 Beta project static checks passed.')
