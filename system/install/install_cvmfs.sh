#!/bin/bash 
# This file is part of CernVM 5. ###
set -e

dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs bash 

# Adding wlcg and cvmfs repositories
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  
dnf -y --installroot=/ --releasever=/ config-manager --add-repo http://ecsft.cern.ch/dist/cernvm/five/
# CernVM config and system
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-config-default-latest-noarch.rpm

dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-system-default-latest-noarch.rpm

# Installing patchELF into base layer image
mkdir -p /tmp_build/patchelf && cd /tmp_build/patchelf
git clone https://github.com/NixOS/patchelf
cd /patchelf
./bootstrap.sh
./configure --prefix=$BUILD_DIR
make
make install