#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -s
res=$?
exit $res
