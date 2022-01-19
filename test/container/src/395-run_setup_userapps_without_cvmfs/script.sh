#!/bin/bash
. ./etc/cernvm/functions
cernvm_config setup_userapps
res=$?
exit $res
