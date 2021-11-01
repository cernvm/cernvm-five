#!/bin/bash
# Running the tests inside the container
. ./run_container.sh
for t in "${testsuite[@]}"
do
  . ./src/$t/main
  log "Started $cvm_test_name"
  cvm_run_test 
done
log "Tests done... stopping container"
exit
