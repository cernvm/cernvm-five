#!/bin/bash
### This file is part of CernVM 5.
# Script is used to build a CernVM 5 config rpm ###
set -e
usage() {
  echo "$0 <rpm nametag> "
}

NAME=$1
if [ -z $NAME ]; then
  usage
  exit 1
fi

REPO_URL="https://github.com/cernvm/cernvm-five"
git clone $REPO_URL
 
cd cernvm-five/rpm
rpmbuild -ba cernvm-config.spec 

DEST_DIR="./rpm_dest"

# move rpm to host mountpoint $DEST_DIR 
mv ~/rpmbuild/RPMS/x86_64/*.rpm $DEST_DIR/${NAME}.rpm