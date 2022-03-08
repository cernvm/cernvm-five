#!/bin/bash
# This file is part of CernVM 5. ###
set -e
# todo: using dnf instead
# Removing packages
sudo rpm --root=$BUILD_DIR -e  cracklib-dicts \
    cracklib \
    adwaita-icon-theme \
    adwaita-cursor-theme \
    findutils \
    cmake \
    rsync \
    diffutils \
    tar \
    binutils \
    hwdata \
    shadow-stils \
    gsettings-desktop-schemas --nodeps  

# Removing cache
sudo rm -r build/var/cache/
dnf clean all

# Can be used to determine over fetched packages
# rpm -qia|awk '$1=="Name" { n=$3} $1=="Size" {s=$3*10^-6} $1=="Description" {print s  " " n }' |sort -n 