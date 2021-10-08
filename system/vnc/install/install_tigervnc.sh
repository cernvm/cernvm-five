#!/bin/bash
# This file is part of CernVM 5.
set -e
dnf install -y --installroot=$BUILD_DIR --releasever=/ --nodocs --setopt=install_weak_deps=False tigervnc-server