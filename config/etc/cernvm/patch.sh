#!/bin/bash
# This file is part of CernVM 5. #
# Sets up rpath for all ELF executable
usage() {
  echo "Script used to add DL_RPATH to ELF executables using patchELF"
  echo "${0} [-r <installation root (by default '/')> | -l <location of shared libraries (by default '/lib64:/lib' resp. '/lib')>"
  return 0
}

is_elf() {
  local f=$1
  if [[ $(file $f | awk '{print $2}') == "ELF" ]]; then
    return 0
fi
return 1
}

is_64bit() {
  local f=$1
  if [[ $(file $f | awk '{print $3}') == "64-bit" ]]; then
    return 0
fi
return 1
}

is_32bit() {
  local f=$1
  if [[ $(file $f | awk '{print $3}') == "32-bit" ]]; then
    return 0
fi
return 1
}

needs_rpath() {
  local f=$1
  if [[ $(patchelf --print-rpath $f) == "" ]]; then
    return 0
  fi
  return 1
}

is_statically_linked() {
  local f=$1
  ldd $f | grep 'statically linked'
  return $?
}
  

set_rpath() {
  local f=$1
  if is_elf $f && needs_rpath $f; then

    if is_statically_linked $f; then
      echo "${f} is statically linked"
      return 0
    fi
  
    if is_64bit $f; then
      echo "setting up rpath ${LOC}/lib64:${LOC}/lib for $f"
      patchelf --force-rpath --set-rpath "${LOC}/lib64:${LOC}/lib" $f
      return $?
    fi

    if is_32bit $f; then
      echo "setting up rpath ${LOC}/lib for $f"
      patchelf --force-rpath --set-rpath "${LOC}/lib" $f
      return $?
    fi
  fi
}

 # Sets up rpath for all ELFs installed in ROOT
run() {
# TODO: Use -exec or use disk
for f in $(find $ROOT -type f -executable)
do
  echo "checking $f"
  set_rpath $f
done
}

# Scratch directory or prefix, e.g. "/build". Default "/".
ROOT="/"
# Final location of lib and lib64, e.g. "/cvmfs.cern.ch/cernvm-five.cern.ch/prefix". Default /lib and /lib64. 
LOC=""
QUIET="false"

while getopts 'r:l:yh' c
do
  case $c in
    r ) ROOT="$OPTARG" ;;
    l ) LOC="$OPTARG" ;;
    y ) QUIET="TRUE" ;;
    h | ? ) usage; exit 0;;
  esac
done

if [[ $CERNVM_SUPRESS_RPATH_PATCHING == "true" ]]; then 
    echo "Environment is set to supress rpath patching"
    echo "CERNVM_SUPRESS_RPATH_PATCHING=${CERNVM_SUPRESS_RPATH_PATCHING}"
    exit 0
  fi

echo "Root directory: ${ROOT}"
echo "rpath (64bit) : ${LOC}/lib64:${LOC}/lib"
echo "rpath (32bit) : ${LOC}/lib"

if [[ $QUIET == "false" ]]; then
  read -r -p "Proceed? [Y/n] " INPUT
  echo $INPUT
  if ! [[ $INPUT == "Y" || $INPUT == "y" ]]; then 
    echo "Abort..."
    exit 0
  fi
fi

run $ROOT $LOC
exit $?