#!/bin/bash
. ./etc/cernvm/cernvm_env.sh
cernvm_config mount -s
cernvm_config setup_systemapps
res=$?
exit $res
