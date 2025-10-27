#!/bin/bash

set -ouex pipefail

### Prepare for stuff that installs to /opt
mkdir -p /var/opt

### Install packages

#dnf -y copr enable gvalkov/vicinae
dnf -y copr enable pgdev/ghostty 

dnf -y install \
    ghostty
#    vicinae

#dnf -y copr disable gvalkov/vicinae
dnf -y copr disable pgdev/ghostty

### Move opt stuff
mv /var/opt /usr/share/factory/var/opt

### Enable services
systemctl enable podman.socket
systemctl enable podman-restart.service

###
authselect current

### Clean up if needed