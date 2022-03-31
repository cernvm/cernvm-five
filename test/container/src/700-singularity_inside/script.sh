#!/bin/bash
set -e
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -a
/cvmfs/oasis.opensciencegrid.org/mis/singularity/current/bin/singularity exec /cvmfs/unpacked.cern.ch/registry.hub.docker.com/library/alpine\:3.10.2/ cat /etc/os-release

exit $?