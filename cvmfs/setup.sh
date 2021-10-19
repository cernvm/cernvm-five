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
    PATH=$PATH:${thisdir}/bin; export PATH
fi

# LD_LIBRARY_PATH
if [ -z "${LD_LIBRARY_PATH}" ]; then
    LD_LIBRARY_PATH=${thisdir}/lib; export LD_LIBRARY_PATH
else
    LD_LIBRARY_PATH=${thisdir}/lib:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH
fi
if [ -d ${thisdir}/lib64 ]; then
    LD_LIBRARY_PATH=${thisdir}/lib64:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH
fi