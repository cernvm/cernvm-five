#!/bin/bash
. ./etc/profile.d/cernvm_env.sh
cernvm_config mount -a
exit $?
