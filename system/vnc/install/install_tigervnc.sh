#!/bin/bash
set -e
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False tigervnc-server