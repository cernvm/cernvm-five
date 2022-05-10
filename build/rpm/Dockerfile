### This file is part of CernVM 5. ###
### Dockerfile for rpm build container ###
FROM rockylinux:8
RUN mkdir -p /build/rpm_dest  

### Install rpm software and set up tree ###
RUN dnf install -y rpmdevtools rpmlint git
RUN rpmdev-setuptree

### Copy build script###     
COPY build/rpm/build_cernvm_config_rpm.sh /build
COPY build/rpm/build_cernvm_system_rpm.sh /build
WORKDIR /build
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Radu Popescu radu.popescu@cern.ch, Jakob Blomer jblomer@cern.ch"