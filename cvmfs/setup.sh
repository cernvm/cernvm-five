#!/bin/bash
# This script sets up the environment for the CernVM Five platform applications.
#---Get the location this script (thisdir)
SOURCE=${BASH_ARGV[0]}
thisdir=$(cd "$(dirname "${SOURCE}")"; pwd)
thisdir=$(readlink -f ${thisdir})

# PATH
if [ -z "${PATH}" ]; then
    PATH=${thisdir}/bin; export PATH
else
    PATH=${thisdir}/bin:$PATH; export PATH
fi
