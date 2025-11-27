#!/bin/bash
set -ouex pipefail

### Example base package
dnf5 install -y tmux

### Dependencies for conversion and Python bindings
dnf5 install -y wget alien python3-pip python3-devel gcc

### Download Coral runtime (Debian package for x86_64)
wget https://packages.cloud.google.com/apt/pool/libe/libedgetpu/libedgetpu1-std_15.0_amd64.deb

### Convert .deb to .rpm and install into the image
alien -r libedgetpu1-std_15.0_amd64.deb
rpm -ivh ./libedgetpu1-std-15.0-1.x86_64.rpm

### Install Python bindings for Coral
pip3 install pycoral

### Add udev rules for Coral USB devices
cat <<'EOF' > /etc/udev/rules.d/99-edgetpu-accelerator.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="1a6e", MODE="0666", GROUP="plugdev"
EOF

### Enable podman socket as in template
systemctl enable podman.socket
