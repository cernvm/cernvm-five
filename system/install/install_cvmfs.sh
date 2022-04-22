#!/bin/bash 
# This file is part of CernVM 5. ###
set -e

# Adding wlcg and cvmfs repositories
dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm
dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  

# CernVM config and system
wget -P / http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-system-default-latest-x86_64.rpm
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs /cernvm-system-default-latest-x86_64.rpm

wget -P / http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-config-default-latest-x86_64.rpm
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs /cernvm-config-default-latest-x86_64.rpm

# Creating .bashrc
# Sourceing cernvm_config, set banner and titel of terminal
echo ". /etc/cernvm/functions && set_banner && set_titel" >> $BUILD_DIR/$HOME/.bashrc

