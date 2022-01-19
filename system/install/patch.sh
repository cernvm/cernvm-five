#!/bin/bash
# Sets up rPath for all ELF executable /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if ! which patchelf; then
  echo "patchelf not installed"
  exit 1
fi 

# Prefix in which target ELFs are installed, for e.g. /build
PREFIX=$1
if [ -z $PREFIX ]; then
  echo "Enter prefix"
  exit 1
fi

# final library location for e.g. / or /cvmfs/cernvm-five.cern.ch/prefix
LIBS=$2
if [ ! -z $LIBS ]; then
  LIB=""
fi

is_elf() {
  if file $1 | grep "ELF 64-bit" || file $1 | grep "ELF 32-bit"; then
    return 0
  fi
  echo "$1 is not an ELF executable"
  echo
  return 1
}

needs_rpath() {
  if [[ $(patchelf --print-rpath $1) == "" ]]; then
    return 0
  fi
  echo
  echo "rPath is already set up for $1"
  return 1
}

set_rpath() {
  patchelf --force-rpath --set-rpath $LIBS/lib:$LIBS/lib64 $1
  return $?
}

# Iterates all prefix files in /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin/sbin /bin and setting up rPath if needed
for f in  $PREFIX/usr/local/sbin/* $PREFIX/usr/local/bin/* $PREFIX/usr/sbin/* $PREFIX/usr/bin/* $PREFIX/sbin/* $PREFIX/bin/*; do
    if is_elf $f && needs_rpath $f; then
      set_rpath $f
      echo "rPath set for $f"
      echo
    fi
done

exit 0

