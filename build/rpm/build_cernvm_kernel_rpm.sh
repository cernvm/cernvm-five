#!/bin/bash
### This file is part of CernVM 5. ###
# Script is used to build a CernVM 5 kernel rpm ###
set -e
usage() {
  echo "$0 <rpm nametag> <jenkins-buildnumber (injected)>"
}

NAME=$1
if [ -z $NAME ]; then
  usage
  exit 1
fi

BUILD_NUMBER=$2
if [ -z $BUILD_NUMBER ]; then
  usage
  exit 1
fi

REPO_URL="https://github.com/cernvm/cernvm-five"
git clone $REPO_URL
cd /build/cernvm-five
rpmbuild -ba ./rpm/cernvm-kernel.spec 

DEST_DIR="/build/rpm_dest"

# move rpm to host mountpoint $DEST_DIR 
mv /root/rpmbuild/RPMS/$(uname -m)/*.rpm $DEST_DIR/${NAME}-1.${BUILD_NUMBER}.$(uname -m).rpm