#!/bin/bash
. ./etc/cernvm/cernvm_env.sh
cernvm_config setup_systemapps
echo $PATH

if [[  "$LD_LIBRARY_PATH" != "" ]]; then
  exit 1
fi
exit 0