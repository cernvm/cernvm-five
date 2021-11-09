#!/bin/bash
### This file is part of CernVM 5.
# Used in a build container
set -e
NAME="cvmvm"
DOCKERFILE="Dockerfile"
TAG="baselayer"
REPO_URL="https://github.com/cernvm/cernvm-five"
OUTPUT_FORMAT="docker"
BUILD_DIR="/build"
DEST_DIR="./image_dest"

git clone $REPO_URL
cd cernvm-five
buildah bud --format "$OUTPUT_FORMAT" -t "$NAME:$VERSION" -f "docker/$DOCKERFILE" . 
buildah push --format "$OUTPUT_FORMAT" "$NAME:$VERSION" docker-archive:"$BUILD_DIR/$NAME.tar"
buildah images
cd $BUILD_DIR
gzip -k -v "$NAME.tar"
# move to host mountpoint $DEST_DIR
mv cvm-five.tar.gz $DEST_DIR/${NAME}-${VERSION}.tar.gz
