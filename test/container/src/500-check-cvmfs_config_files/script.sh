#!/bin/bash
# Array files for all checked files in image
files=("/etc/profile.d/cernvm_env.sh" "/etc/cernvm/cernvm_config" "/etc/cvmfs/config.d/cernvm-five.cern.ch.conf" "/etc/cvmfs/default.d/90-cernvm.conf" "/etc/cvmfs/keys/cernvm-five.cern.ch.pub")
fail= 
for f in "${files[@]}"
do
  if [ ! -f $f  ]; then
    fail="true"
    echo "$f is missing"
  fi
done

if [[ $fail == "true" ]]; then
  exit 1
fi

exit 0

