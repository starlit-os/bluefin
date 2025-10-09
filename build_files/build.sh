#!/bin/bash

set -ouex pipefail

### Prepare for stuff that installs to /opt
mkdir -p /var/opt

### Install packages

dnf -y copr enable gvalkov/vicinae
dnf -y config-manager setopt terra.enabled=1

dnf -y install \
	coolercontrol \
    headsetcontrol \
	liquidctl \
    lutris \
    openrgb \
    https://vencord.dev/download/vesktop/amd64/rpm \
    vicinae \
    warp-terminal

### Move opt stuff
rm /usr/bin/warp-terminal
ln -s /opt/warpdotdev/warp-terminal/warp /usr/bin/warp-terminal

mv /var/opt /usr/share/factory/var/opt

### Enable services
systemctl enable podman.socket
systemctl enable podman-restart.service
