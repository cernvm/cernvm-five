#!/bin/bash
. ./etc/cernvm/cernvm_env.sh
cernvm_config mount -a
res=$?
exit $res
