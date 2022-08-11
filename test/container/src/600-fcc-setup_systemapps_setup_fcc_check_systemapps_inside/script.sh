#!/bin/bash
. ./etc/profile.d/cernvm_env.sh
. ../systemapps
cernvm_config mount -a
. /cvmfs/sw.hsf.org/spackages4/key4hep-stack/release-2021-10-29-ip7764o/x86_64-centos8-gcc8.4.1-opt/setup.sh

fail=
for a in "${apps[@]}"
do
  which $a
  if [ $? -ne 0 ]; then
    fail="true"
  fi
done
 
if [[ $fail == "true" ]]; then
    exit 1
fi
exit 0