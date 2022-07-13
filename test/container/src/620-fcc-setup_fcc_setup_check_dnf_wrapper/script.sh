#!/bin/bash
set -e
cernvm_config mount -a
. /cvmfs/sw.hsf.org/spackages4/key4hep-stack/release-2021-10-29-ip7764o/x86_64-centos8-gcc8.4.1-opt/setup.sh
wrapped_dnf install -y -v --nogpgcheck nautilus --nodocs

exit $?