### This file is part of CernVM 5. ### 
### This is a multi-stage Dockerfile used for building CernVM 5. ### 
### The final image contains a CernVM-FS client and the HEP_OSlibs. It can be used to derive from it. ###

### Build Stage, preparing a EL8-based builder container ###
FROM centos:8 AS builder
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

### Install CernVM-FS, HEP_OSlibs and dnf into /build ###
COPY /system/install/install_cvmfs.sh /
RUN bash install_cvmfs.sh

### Removing some unnecessary packages and caches ###
COPY /system/minimization/minimization.sh /
RUN bash minimization.sh

### Final Stage ###
### Copying /build to scratch ###
FROM scratch as cernvm
COPY --from=builder /build /
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Radu Popescu radu.popescu@cern.ch, Jakob Blomer jblomer@cern.ch" 
LABEL io.k8s.display-name="CernVM" 
LABEL io.k8s.description="A container image providing cvmfs and HEP_OSlibs"
WORKDIR /
STOPSIGNAL SIGINT