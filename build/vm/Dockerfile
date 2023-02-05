### This file is part of CernVM 5. ###
### Dockerfile for the vm builder container ###
### First build Buildah container locally (to avoid automatic pull) https://github.com/containers/buildah 
### buildah bud --format docker -t localhost/redhat_builder_local -f contrib/docker/Dockerfile .
FROM localhost/redhat_builder_local 
RUN dnf -y install e2fsprogs kpartx syslinux-extlinux gdisk git
RUN mkdir /rootfs /dest /build

### Copy build script ###     
COPY build/vm/create_rootfs.sh /
COPY build/vm/extend_to_vm.sh /
WORKDIR /
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Jakob Blomer jblomer@cern.ch"