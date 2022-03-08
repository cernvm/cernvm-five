#!/bin/bash
. ./etc/cernvm/functions
cernvm_config setup_systemapps
res=$?
exit $res
