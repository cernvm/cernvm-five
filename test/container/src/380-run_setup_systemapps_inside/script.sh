#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -s
cernvm_config setup_systemapps
res=$?
exit $res
