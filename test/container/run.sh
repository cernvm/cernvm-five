#!/bin/bash
# Running the tests inside the container
logfile=$1
testsuite=$2
test_dir=/test
# logger
log() {
echo '['$(date +"%D %T %z")'][C]' $1 | tee -a $logfile
}
cd $test_dir
for t in "${testsuite[@]}"
do
  . ./src/$t/main
  log "Started $cvm_test_name"
  cvm_run_test 
done
log "Tests done... stopping container"
exit

