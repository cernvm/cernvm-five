#!/bin/bash
set -e
. ./etc/cernvm/cernvm_env.sh
cernvm_config mount -a
/cvmfs/oasis.opensciencegrid.org/mis/singularity/current/bin/singularity exec /cvmfs/unpacked.cern.ch/registry.hub.docker.com/library/alpine\:3.10.2/ cat /etc/os-release

exit $?