#!/bin/bash
### This file is part of CernVM 5.###
### Checks host and runs test ###

# Source helper functions
. ./test_functions 

logfile=$1
if [ -z $logfile ]; then
  usage
  exit 1
fi

image=$2
if [ -z $image ]; then
  usage
  exit 1
fi

cvmfs_mount=$3
if [ $cvmfs_mount != "-i" ] && [ $cvmfs_mount != "-h" ] && [ $cvmfs_mount != "-a" ]; then
  usage
  exit 1
fi

testsuite=$4
if [ -z $testsuite ]; then
  usage
  exit 1
fi

skip=$5
if [ -z $skip ]; then
  usage
  exit 1
fi

log "Hostname: $(hostname)"
log "Image: $image"
log 

# thisdir
SOURCE=${BASH_ARGV[0]}
thisdir=$(cd "$(dirname "${SOURCE}")"; pwd)
thisdir=$(readlink -f ${thisdir})
log "Workingdirectory:"$thisdir

#directories to be mounted during tests
host_test_dir=$thisdir
container_test_dir=/test
workspace_host=$thisdir/workspace_host
data_host=$thisdir/data_host

# Mapping testsuite and skipped tests
mapfile -t testsuite < $testsuite
num_tests=${#testsuite[@]}
mapfile -t skip < $skip

#todo: implement xUnit
for t in "${testsuite[@]}"
do
  . ./src/$t/main

  # Check CernVM mount specification
  if [ "$cvmfs_mount" != "-a" ]; then 
    if [[ ! "${tags[*]}" =~ "$cvmfs_mount" ]]; then
      skip+=("$t")
      log "Adding $t to tests to be skipped..." 
    fi
  fi

  if [[ "${skip[*]}" =~ "$t" ]]; then
  log "Skipping Test $cvm_test_name"
  echo
  continue
  fi

  log "Starting Test $cvm_test_name"
  cvm_run_test
  if [ $? != "0" ]; then
    log "Test $cvm_test_name FAILED"
    failed+=("$t")
  else 
    log "Test $cvm_test_name PASSED" 
    passed+=("$t")
   fi
   echo
done

# Summary
log "PASSED:"
for p in "${passed[@]}"
do
  log "Test $p passed"
done
echo

log "FAILED:"
for f in "${failed[@]}"
do
  log "Test $f failed"
done
echo

log "SKIPPED:"
for s in "${skip[@]}"
do
  log "Test $s was skipped"
done
echo

log "Summary:"
log "${#passed[@]} of ${num_tests} tests passed"
log "${#failed[@]} of ${num_tests} tests failed"
log "${#skip[@]} of ${num_tests} tests skipped"

if [ ${#failed[@]} -gt 0 ]; then
  exit 1
fi

if [ ${#skip[@]} == ${num_tests} ]; then
  exit 2
fi

exit 0