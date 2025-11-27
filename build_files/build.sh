#!/bin/bash

set -ouex pipefail

### Install packages

# Example: install tmux from Fedora repos
dnf5 install -y tmux

# Coral runtime and bindings
dnf5 install -y \
  libedgetpu1-std \
  python3-pycoral \
  libusb1

# Add udev rules for Coral USB devices
cat <<'EOF' > /etc/udev/rules.d/99-edgetpu-accelerator.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="1a6e", MODE="0666", GROUP="plugdev"
EOF

#### Example for enabling a System Unit File
systemctl enable podman.socket
