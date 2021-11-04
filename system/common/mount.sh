#!/bin/bash
# This file is part of CernVM 5.
# Mounting every repo specified in /etc/cvmfs/default.local 
. /etc/cvmfs/default.local 
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

exit $res