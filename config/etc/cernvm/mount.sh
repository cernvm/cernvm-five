#!/bin/bash
# This file is part of CernVM 5.
# Mounting every repo specified in /etc/cvmfs/default.local 

if [ "$(cvmfs_config status)" != "" ]; then
  exit 0

# draft
else
  . /etc/cvmfs/default.d/90-cernvm.conf 
  repos=(${CVMFS_REPOSITORIES//,/ })
  res=0
  for r in "${repos[@]}"
  do
    mkdir -p /cvmfs/$r 
    mount -t cvmfs $r /cvmfs/$r
    if [ $? -ne 0 ]; then
      res=1
    fi
  done
fi

exit $res