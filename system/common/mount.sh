#!/bin/bash
# This file is part of CernVM 5.
# Mounting every repo specified in /etc/cvmfs/default.local 
. /etc/cvmfs/default.local 
repos=(${CVMFS_REPOSITORIES//,/ })
for r in "${repos[@]}"
do
  mkdir -p /cvmfs/$r 
  mount -t cvmfs $r /cvmfs/$r
done