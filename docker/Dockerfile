### This file is part of CernVM 5. ### 
### Build Stage, preparing a EL8-based builder container ###
FROM centos:8 AS builder
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
ENV BUILD_DIR=/build 
WORKDIR /

### Install builder packages ###
COPY /system/install/dnf.conf /etc/dnf/dnf.conf 
RUN dnf install sudo                                                                \
    https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm          \
    https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm  \
    wget        \
    which       \
    git         \
    autoconf    \
    make        \
    gcc         \
    gcc-c++     \
    gdb         \
    glibc-devel \
    libtool

### Install patchELF https://github.com/NixOS/patchelf
RUN git clone https://github.com/NixOS/patchelf && \
    cd /patchelf &&    \
    ./bootstrap.sh &&  \
    ./configure &&     \
    make &&            \
    make install &&    \
    dnf install -y grep findutils file    
WORKDIR /    

### Installing into /build via root install ###
RUN mkdir build
RUN dnf install --installroot=$BUILD_DIR --releasever=/ --nodocs glibc-langpack-en dnf
RUN sed -i 's/mirrorlist/#mirrorlist/g' $BUILD_DIR/etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' $BUILD_DIR/etc/yum.repos.d/CentOS-*

### Install CernVM-FS, HEP_OSlibs and dnf into /build ###
COPY /system/install/install_cvmfs.sh /
RUN bash install_cvmfs.sh

### Add rPath to ELF executables ###
COPY /system/install/patch.sh /
RUN bash patch.sh $BUILD_DIR 

### Create mountpoints
RUN mkdir $BUILD_DIR/workspace
RUN mkdir $BUILD_DIR/data

### Removing some unnecessary packages and caches ###
COPY /system/minimization/minimization.sh /
RUN bash minimization.sh

### Final Stage ###
### Copying /build to scratch ###
FROM scratch as cernvm
COPY --from=builder /build /
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Radu Popescu radu.popescu@cern.ch, Jakob Blomer jblomer@cern.ch" 
LABEL io.k8s.display-name="CernVM" 
LABEL io.k8s.description="A container image providing CernVM-FS and HEP_OSlibs"
WORKDIR /
STOPSIGNAL SIGINT