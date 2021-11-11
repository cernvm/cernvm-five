  GNU nano 2.9.8                                                                                                                            build.sh                                                                                                                            Modified  

#!/bin/bash
### This file is part of CernVM 5.
# Script is used in a Buildah container to build a tagged image
# Image: https://github.com/containers/buildah
set -e
usage() {
  echo "$0 <image nametag> <image versiontag> <output format e.g. docker> "
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

REPO_URL="https://github.com/cernvm/cernvm-five"

# Image is exported to BUILD_DIR_CONTAINER
BUILD_DIR_CONTAINER="/build"

# Image is copied to host mountpoint DEST_DIR
DEST_DIR="./image_dest"

git clone $REPO_URL
cd cernvm-five
# todo: Buildah via https
buildah bud --format "$OUTPUT_FORMAT" -t "$NAME:$VERSION" -f "docker/Dockerfile" . 
buildah push --format "$OUTPUT_FORMAT" "$NAME:$VERSION" docker-archive:"$BUILD_DIR_CONTAINER/$NAME.tar"
buildah images
cd $BUILD_DIR_CONTAINER
gzip -k -v "$NAME.tar"

# move image to host mountpoint $DEST_DIR as .tar.gz
mv $NAME.tar.gz $DEST_DIR/${NAME}-${VERSION}.tar.gz





















^G Get Help	 ^O Write Out     ^W Where Is	   ^K Cut Text      ^J Justify       ^C Cur Pos       M-U Undo         M-A Mark Text    M-] To Bracket   M-▲ Previous     ^B Back          ^◀ Prev Word     ^A Home          ^P Prev Line     M-- Scroll Up    ^▲ Prev Block
^X Exit          ^R Read File     ^\ Replace	   ^U Uncut Text    ^T To Linter     ^_ Go To Line    M-E Redo         M-6 Copy Text    M-W WhereIs Next M-▼ Next         ^F Forward	   ^▶ Next Word     ^E End           ^N Next Line     M-+ Scroll Down  ^▼ Next Block
