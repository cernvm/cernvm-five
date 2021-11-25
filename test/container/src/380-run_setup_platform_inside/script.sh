#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -p
cernvm_config setup_platform
res=$?
exit $res
