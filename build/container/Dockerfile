### Dockerfile for the builder container ###

### First build Buildah container locally (no pull) https://github.com/containers/buildah 
FROM localhost/redhat_builder_local 
RUN mkdir -p /build/image_dest  

### Install rpm software and set up tree ###
RUN dnf install -y rpmdevtools rpmlint git
RUN rpmdev-setuptree

### Copy build script###     
COPY build/container/build_image.sh /build
WORKDIR /build