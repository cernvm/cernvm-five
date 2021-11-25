#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -p 
cernvm_config setup_platform
echo $PATH

if [[  "$LD_LIBRARY_PATH" != "" ]]; then
  exit 1
fi
exit 0