### This file is part of CernVM 5. ###
### Dockerfile for the builder container ###
### First build Buildah container locally (to avoid automatic pull) https://github.com/containers/buildah 
### sudo buildah bud --format docker -t localhost/redhat_builder_local -f contrib/docker/Dockerfile .
FROM localhost/redhat_builder_local 
RUN mkdir -p /build/image_dest  

### Install rpm software and set up tree ###
RUN dnf install -y rpmdevtools rpmlint git
RUN rpmdev-setuptree

### Copy build script ###     
COPY build/container/build_image.sh /build
WORKDIR /build
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Radu Popescu radu.popescu@cern.ch, Jakob Blomer jblomer@cern.ch"