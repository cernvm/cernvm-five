#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -a
res=$?
exit $res
