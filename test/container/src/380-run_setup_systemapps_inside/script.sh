#!/bin/bash
. ./etc/cernvm/cernvm_env.sh
cernvm_config mount -s
res=$?
exit $res
