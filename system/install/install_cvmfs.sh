#!/bin/bash 
# This file is part of CernVM 5. ###
set -e
# todo: building a single rpm

# Used for docker
dnf install --installroot=$BUILD_DIR  --releasever=/ --nodocs libXpm \
     xauth \
     PackageKit-gtk3-module  #root: error while loading shared libraries: libXft.so.2: cannot open shared object file: No such file or directory

# HEP_OSlibs
dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm 
dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs HEP_OSlibs

# dnf packagemanager
dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs dnf

# CernVM-FS
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs cvmfs 

# CernVM config and helper functions
# todo: Add RPM version to rolling tag
wget -P / http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-config-default-latest-x86_64.rpm
rpm -i --root $BUILD_DIR /cernvm-config-default-latest-x86_64.rpm

# Creating .bashrc
# Sourceing cernvm_config, set banner and titel of terminal
echo ". /etc/cernvm/functions && set_banner && set_titel" >> $BUILD_DIR/$HOME/.bashrc

# create mountpoints
mkdir $BUILD_DIR/workspace
mkdir $BUILD_DIR/data