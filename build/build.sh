#!/bin/bash
# Used in a build container
set -e
TAG="cvm"
DOCKERFILE="Dockerfile"
KIND="baselayer"
VERSION="latest"
REPO_URL="https://github.com/cernvm/cernvm-five"
OUTPUT_FORMAT="docker"
BUILD_DIR="/build"

git clone $REPO_URL
cd cernvm-five
buildah bud --format "$OUTPUT_FORMAT" -t "$TAG:$VERSION" -f "docker/$DOCKERFILE.$KIND" . 
buildah push --format "$OUTPUT_FORMAT" "$TAG:$VERSION" docker-archive:"$BUILD_DIR/$TAG.tar"
buildah images
cd $BUILD_DIR
gzip -k -v "$TAG.tar"
ls -lah $BUILD_DIR
cp *.gz ./image_dest
