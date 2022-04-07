#!/bin/bash
### This file is part of CernVM 5.
# For e.g. sudo podman run -it --rm --device /dev/fuse --cap-add SYS_ADMIN -v ~/tmp:/build/image_dest:Z builder bash build_image.sh "cernvm" "5" "docker" "x86_64"
# Script is used in a Buildah container to build a tagged image
# Image: https://github.com/containers/buildah
set -e
usage() {
  echo "$0 <image nametag> <image versiontag> <output format e.g. docker> <arch>"
}

NAME=$1
if [ -z $NAME ]; then
  usage
  exit 1
fi

VERSION=$2
if [ -z $VERSION ]; then
  usage
  exit 1
fi

OUTPUT_FORMAT=$3
if [ -z $OUTPUT_FORMAT ]; then
  usage
  exit 1
fi

ARCH=$4
if [ -z $ARCH ]; then
  usage
  exit 1
fi

REPO_URL="https://github.com/cernvm/cernvm-five"

# Image is exported to BUILD_DIR_CONTAINER
BUILD_DIR_CONTAINER="/build"

# Image is copied to host mountpoint DEST_DIR
DEST_DIR="./image_dest"

git clone $REPO_URL
cd cernvm-five
buildah bud --format "$OUTPUT_FORMAT" -t "$NAME:$VERSION-$OUTPUT_FORMAT-$ARCH" -f "docker/Dockerfile" .
buildah push --format "$OUTPUT_FORMAT" "$NAME:$VERSION-$OUTPUT_FORMAT-$ARCH" docker-archive:"$BUILD_DIR_CONTAINER/$NAME.tar"
buildah images
cd $BUILD_DIR_CONTAINER
gzip -k -v "$NAME.tar"

# move image to host mountpoint $DEST_DIR as .tar.gz
echo "Copying image to ${DEST_DIR}"
mv $NAME.tar.gz ${DEST_DIR}/${NAME}-${VERSION}-${OUTPUT_FORMAT}-${ARCH}.tar.gz
exit $?