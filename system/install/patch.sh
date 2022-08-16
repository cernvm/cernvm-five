#!/bin/bash
# This file is part of CernVM 5. #
# Sets up rpath for all ELF executable
if ! which patchelf; then
  echo "patchelf not installed"
  exit 1
fi 

# Scratch directory or prefix, e.g. "/build". Default "/".
ROOT=$1
if [[ -z $ROOT ]];then 
  ROOT="/"
fi

# Final location of lib and lib64, e.g. "/cvmfs.cern.ch/cernvm-five.cern.ch/prefix". Default /lib and /lib64. 
LOC=$2
if [[ -z $LOC ]];then 
  LOC=""
fi

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

# Set up rpath
# TODO: Use -exec
for f in $(find $ROOT -type f -executable)
do
  echo "checking $f"
  set_rpath $f
done