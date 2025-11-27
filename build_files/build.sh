#!/bin/bash
set -ouex pipefail

# Example base package
dnf5 install -y tmux

# Tooling for conversion + Python dev
dnf5 install -y wget alien python3-pip python3-devel gcc

# Coral runtime: download, convert, install
wget https://packages.cloud.google.com/apt/pool/libe/libedgetpu/libedgetpu1-std_15.0_amd64.deb
alien -r libedgetpu1-std_15.0_amd64.deb
rpm -ivh ./libedgetpu1-std-15.0-1.x86_64.rpm

# Python bindings
pip3 install pycoral

# Udev rules for Coral USB
cat <<'EOF' > /etc/udev/rules.d/99-edgetpu-accelerator.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="1a6e", MODE="0666", GROUP="plugdev"
EOF

# Enable podman socket
systemctl enable podman.socket
