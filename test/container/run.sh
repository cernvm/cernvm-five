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

if [ $6 ]; then
 xml_file=$6
 touch $xml_file
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
t_start_testrun=$(set_t_start)

for t in "${testsuite[@]}"
do
  . ./src/$t/main

  # Check CernVM mount specification
  if [ "$cvmfs_mount" != "-a" ]; then 
    if [[ ! "${tags[*]}" =~ "$cvmfs_mount" ]] && [[ ! "${skip[*]}" =~ "$t" ]]; then
      skip+=("$t")
      log "Adding $t to tests to be skipped..." 
    fi
  fi

  if [[ "${skip[*]}" =~ "$t" ]]; then
  log "Skipping Test $cvm_test_name"
  xunit_skiped
  echo
  continue
  fi

  log "Starting Test $cvm_test_name"
  t_start_casetime=$(set_t_start)
  cvm_run_test
  retval=$?
  if [ $retval != "0" ]; then
    log "Test $cvm_test_name FAILED"
    xunit_failed
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


xunit_preamble
xunit_epilogue

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