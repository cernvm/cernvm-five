#!/bin/bash
# Running the tests inside the container
logfile=$1
testsuite=$2
test_dir=/test
passed=0
failed=0

# logger
log() {
  echo '['$(date +"%D %T %z")'][C]' $1 | tee -a $logfile
}

cd $test_dir

mapfile -t testsuite < $2
num_tests=${#testsuite[@]}

for t in "${testsuite[@]}"
do
  . ./src/$t/main
  log "Started $cvm_test_name"
  cvm_run_test
  if [ $? != "0" ]; then
    log "Test $cvm_test_name FAILED"
    ((failed++))
  else 
    log "Test $cvm_test_name PASSED" 
    ((passed++))
   fi
done

log "Tests done... stopping container"
log "${passed} of ${num_tests} tests passed"
log "${failed} of ${num_tests} tests failed"

exit

