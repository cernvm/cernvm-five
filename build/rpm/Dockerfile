### Dockerfile for rpm build container ###

FROM centos:8
RUN mkdir -p /build/image_dest  

### Install rpm software and set up tree ###
RUN dnf install -y rpmdevtools rpmlint
RUN rpmdev-setuptree

### Copy build script###     
COPY build/container/build_cernvm_config_rpm.sh /build
WORKDIR /build