#!/bin/bash

set -ouex pipefail

### Prepare for stuff that installs to /opt
mkdir -p /var/opt

### Install packages

dnf -y copr enable gvalkov/vicinae
dnf -y config-manager setopt rpmfusion*.enabled=1 terra.enabled=1

dnf -y install \
	coolercontrol \
    headsetcontrol \
	liquidctl \
    lutris \
    openrgb \
    https://vencord.dev/download/vesktop/amd64/rpm \
    vicinae \
    warp-terminal

dnf -y copr disable gvalkov/vicinae
dnf -y config-manager setopt rpmfusion*.enabled=0 terra.enabled=0 warpdotdev.enabled=0


### Move opt stuff
rm /usr/bin/warp-terminal
ln -s /opt/warpdotdev/warp-terminal/warp /usr/bin/warp-terminal

mv /var/opt /usr/share/factory/var/opt

### Enable services
systemctl enable podman.socket
systemctl enable podman-restart.service
