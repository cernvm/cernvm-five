### This file is part of CernVM 5.
### This is a multi-stage Dockerfile used for building CernVM 5. 
### The final image contains a cvmfs client and the HEP_OSlibs. It can be used to derive from it. 

### Build Stage, preparing a EL8-based builder container ###
FROM centos:centos8 AS builder
ENV BUILD_DIR=/build 
WORKDIR /

### Install builder packages ###
RUN dnf install -y sudo \
    https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm \
    wget 

### Installing into /build via rootinstall ###
RUN mkdir build

### Install cvmfs, HEP_OSlibs and dnf into /build ###
COPY /system/install/install_cvmfs.sh /
RUN bash install_cvmfs.sh

### Removing some unnecessary packages and caches ###
COPY /system/minimization/minimization.sh /
RUN bash minimization.sh

### Adding config files and runtime scripts ###
COPY /config/etc/cvmfs/default.local $BUILD_DIR/etc/cvmfs/
COPY /config/etc/cvmfs/config.d/cernvm-five.cern.ch.conf $BUILD_DIR/etc/cvmfs/config.d/
COPY /config/etc/cvmfs/keys/cernvm-five.cern.ch.pub $BUILD_DIR/etc/cvmfs/keys/
COPY /system/common/mount.sh $BUILD_DIR/

### Final Stage ###
### Copying /build to scratch ###
FROM scratch as cernvm
COPY --from=builder /build /
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Jakob Blomer jblomer@cern.ch" 
LABEL io.k8s.display-name="CernVM" 
LABEL io.k8s.description="A container image providing cvmfs and HEP_OSlibs"
WORKDIR /
