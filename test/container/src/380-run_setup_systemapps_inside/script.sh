#!/bin/bash
. ./etc/profile.d/cernvm_env.sh
cernvm_config mount -s
cernvm_config version
exit $?