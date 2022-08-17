#!/bin/bash
### This file is part of CernVM 5. ###
# Script is used to build a CernVM 5 config rpm ###
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

CVM_SOURCE_LOCATION="config/etc"
CVM_RESULT_LOCATION="/root/rpmbuild"

REPO_URL="https://github.com/cernvm/cernvm-five"
git clone $REPO_URL

cd /build/cernvm-five
cp ${CVM_SOURCE_LOCATION}/cernvm/cernvm_env.sh                    ${CVM_RESULT_LOCATION}/SOURCES
cp ${CVM_SOURCE_LOCATION}/cvmfs/config.d/cernvm-five.cern.ch.conf ${CVM_RESULT_LOCATION}/SOURCES
cp ${CVM_SOURCE_LOCATION}/cvmfs/default.d/90-cernvm.conf          ${CVM_RESULT_LOCATION}/SOURCES
cp ${CVM_SOURCE_LOCATION}/cvmfs/keys/cernvm-five.cern.ch.pub      ${CVM_RESULT_LOCATION}/SOURCES
cp ${CVM_SOURCE_LOCATION}/cernvm/cernvm_config                    ${CVM_RESULT_LOCATION}/SOURCES
cp ${CVM_SOURCE_LOCATION}/cernvm/patch.sh                         ${CVM_RESULT_LOCATION}/SOURCES

rpmbuild -ba ./rpm/cernvm-config.spec 

DEST_DIR="/build/rpm_dest"

# move rpm to host mountpoint $DEST_DIR 
mv /root/rpmbuild/RPMS/noarch/*.rpm $DEST_DIR/${NAME}-1.${BUILD_NUMBER}.noarch.rpm