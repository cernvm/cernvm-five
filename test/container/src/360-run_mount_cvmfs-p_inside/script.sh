#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -p
res=$?
exit $res
