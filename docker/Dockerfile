### This file is part of CernVM 5. ### 
### Build Stage, preparing a EL8-based builder container ###
FROM gitlab-registry.cern.ch/linuxsupport/cs9-base AS builder
ENV BUILD_DIR=/build 
WORKDIR /

### Install builder packages ###
COPY /system/dnf.conf /etc/dnf/dnf.conf
RUN dnf update && dnf clean all 
RUN dnf install dnf-plugins-core
RUN dnf install autoconf \
    epel-release  \
    file          \
    findutils     \
    gcc           \
    gcc-c++       \
    gdb           \
    git           \
    glibc-devel   \
    grep          \
    https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm  \
    https://linuxsoft.cern.ch/wlcg/el9/x86_64/wlcg-repo-1.0.0-1.el9.noarch.rpm      \
    libtool       \
    make          \
    wget          \
    which         

### Install patchELF https://github.com/NixOS/patchelf
RUN git clone https://github.com/NixOS/patchelf && \
    cd /patchelf &&    \
    ./bootstrap.sh &&  \
    ./configure &&     \
    make &&            \
    make install
WORKDIR /    

### Installing into /build via root install ###
RUN mkdir build

### Install CernVM-FS, HEP_OSlibs and dnf into /build ###
COPY /system/install_cvmfs.sh /
RUN bash install_cvmfs.sh
WORKDIR /

### Add rpath to ELF executables ###
COPY config/etc/cernvm/patch.sh /
RUN bash patch.sh -y -r $BUILD_DIR 
WORKDIR /

### Create mountpoints ###
RUN mkdir $BUILD_DIR/workspace
RUN mkdir $BUILD_DIR/data

### Final Stage ###
### Copying /build to scratch ###
FROM scratch AS cernvm
ONBUILD RUN bash /etc/cernvm/patch.sh -y 
COPY --from=builder /build /
LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Radu Popescu radu.popescu@cern.ch, Jakob Blomer jblomer@cern.ch" 
LABEL io.k8s.display-name="CernVM" 
LABEL io.k8s.description="A container image providing CernVM-FS and HEP_OSlibs"
EXPOSE 8888
STOPSIGNAL SIGTERM
WORKDIR /
CMD [ "bash" ]