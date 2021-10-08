#!/bin/bash 
# This file is part of CernVM 5.
set -e
# Used for docker
dnf install --installroot=$BUILD_DIR --releasever=/  --nodocs --setopt=install_weak_deps=False -y libXpm \
     xauth \
     PackageKit-gtk3-module  #root: error while loading shared libraries: libXft.so.2: cannot open shared object file: No such file or directory

# HEP_OSlibs
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm 
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False HEP_OSlibs

# dnf packagemanager
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False dnf

# cvmfs
sudo dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False  -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  
sudo dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False cvmfs 
