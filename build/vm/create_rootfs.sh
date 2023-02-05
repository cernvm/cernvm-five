#!/bin/bash 
### This file is part of CernVM 5. ###
### Script to prepare CernVM 5 root filesystem for full virtualization
### Installs cernvm-kernel-default and sets up initial ram disk and system services
### Write constructed rootfs to disk
### E.g. docker run --privileged -v ~/rootfs/:/dest/:Z localhost/vmbuilder bash create_rootfs.sh
BASE_IMAGE=$1
if [[ -z $BASE_IMAGE ]]; then
  BASE_IMAGE="registry.cern.ch/cernvm/five/cernvm-five:latest"
fi

REPO_URL="https://github.com/cernvm/cernvm-five"
git clone $REPO_URL
cd cernvm-five
buildah bud --build-arg BASE="$BASE_IMAGE" -t "localhost/image" --format docker -f "vm/docker/Dockerfile.kernel" .
buildah push --format docker "localhost/image" docker-archive:"/dest/rootfs.tar"
exit $?