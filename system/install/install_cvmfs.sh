#!/bin/bash 
# This file is part of CernVM 5. ###
set -e

dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs bash 

# Adding wlcg and cvmfs repositories
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  

# CernVM config and system
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-config-default-latest-x86_64.rpm

dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-system-default-latest-x86_64.rpm

# Sourceing cernvm_config, set banner and titel of terminal
# TODO: Use bash profile
echo "# Source CernVM 5 specific functions. Set banner and terminal title
# https://github.com/cernvm/cernvm-five
. /etc/cernvm/functions && set_banner && set_titel" >> $BUILD_DIR/$HOME/.bashrc

dnf -y --installroot=$BUILD_DIR clean all