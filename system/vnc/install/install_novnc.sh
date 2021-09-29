#!/bin/bash
set -e
#numpy for websockify
dnf install --installroot=$BUILD_DIR --releasever=/ -y python3-numpy
mkdir -p $BUILD_DIR/$NO_VNC_HOME/utils/websockify
wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz | tar xz --strip 1 -C $BUILD_DIR/$NO_VNC_HOME
wget -qO- https://github.com/novnc/websockify/archive/refs/tags/v0.10.0.tar.gz | tar xz --strip 1 -C $BUILD_DIR/$NO_VNC_HOME/utils/websockify
chmod +x -v $BUILD_DIR/$NO_VNC_HOME/utils/*.sh
# ## create index.html to forward automatically to `vnc_lite.html`
ln -s $BUILD_DIR/$NO_VNC_HOME/vnc_lite.html $BUILD_DIR/$NO_VNC_HOME/index.html




# Evt. older version of websockify needed (v.0.6.1)