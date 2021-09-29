#!/bin/bash
set -e
#removing packages
sudo rpm --root=$BUILD_DIR -e  cracklib-dicts \
    cracklib \
    adwaita-icon-theme \
    adwaita-cursor-theme \
    gsettings-desktop-schemas --nodeps  

#removing cache
sudo rm -r build/var/cache/
dnf clean all

# rpm -qia|awk '$1=="Name" { n=$3} $1=="Size" {s=$3*10^-6} $1=="Description" {print s  " " n }' |sort -n 
