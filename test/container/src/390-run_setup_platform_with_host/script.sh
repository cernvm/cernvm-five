#!/bin/bash
. ./etc/cernvm/functions
cernvm_config setup_platform
res=$?
exit $res
