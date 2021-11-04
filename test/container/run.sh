#!/bin/bash
# Running the tests inside the container
test_dir=/test
passed=()
failed=()

usage() {
  echo "$0 </path/to/logfile> <mount /cvmfs inside -i or from host -h> <testsuite> <skip>"
}

logfile=$1
if [ -z $logfile ]; then
  usage
  exit 1
fi

cvmfs_mount=$2
if [ -z $cvmfs_mount ]; then
  usage
  exit 1
fi

testsuite=$3
if [ -z $testsuite ]; then
  usage
  exit 1
fi

skip=$4
if [ -z $skip ]; then
  usage
  exit 1
fi

# logger
log() {
  echo '['$(date +"%D %T %z")'][C]' $1 | tee -a $logfile
}

cd $test_dir

mapfile -t testsuite < $testsuite
num_tests=${#testsuite[@]}
mapfile -t skip < $skip
# todo: fix mountstyle 
for t in "${testsuite[@]}"
do
  . ./src/$t/main
  log "$cvmfs_style ---------------------------------------"
  if [ -z $cvmfs_style ]; then
    if [ $cvmfs_style != $cvmfs_mount ]; then
      skip+=("$t")
      log "Skipping $t, testcase for CernVM mountstyle $cvmfs_style"
    fi
  fi
done



for t in "${testsuite[@]}"
do
  . ./src/$t/main
  if  echo "${skip[@]}" | grep -q "$t" ; then
  log "Skipping Test $cvm_test_name"
  echo
  continue
  fi

  log "Started Test $cvm_test_name"
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


# leaving container
exit

