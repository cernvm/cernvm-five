#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -u
res=$?
exit $res
