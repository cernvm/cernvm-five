#!/bin/bash
# This file is part of CernVM 5.
set -e
# reversing the minimization and installing Xfce
dnf install -y --installroot=$BUILD_DIR --releasever=/ epel-release
dnf --enablerepo=epel -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False -x gnome-keyring --skip-broken groups install "Xfce" 
dnf -y --installroot=$BUILD_DIR --releasever=/ groups install "Fonts"
dnf clean all
rm $BUILD_DIR/etc/xdg/autostart/xfce-polkit*
/bin/dbus-uuidgen > /etc/machine-id