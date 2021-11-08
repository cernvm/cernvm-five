#!/bin/bash
# Checks host and runs test 
usage() {
  echo "$0 </path/to/logfile> <image:version> <mount /cvmfs inside -i, from host -h or -a for all> <testsuite> <skip>"
}

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
if [ $cvmfs_mount != "-i" ] && [ $cvmfs_mount != "-h" ]; then
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

# logger
log() {
echo '['$(date +"%D %T %z")']' $1 | tee -a $logfile
}

log "Hostname: $(hostname)"
log "Image: $image"
log 

# thisdir
SOURCE=${BASH_ARGV[0]}
thisdir=$(cd "$(dirname "${SOURCE}")"; pwd)
thisdir=$(readlink -f ${thisdir})
log "Workingdirectory:"$thisdir


# Checks dockerinstallation
check_docker() {
docker --version  
if [ $? -ne 0 ]; then
  log "docker not installed... Abort"
  exit 1
else 
  log "Running $(docker --version)"
fi
}

# Checks for dockerimage to be tested
Check_docker_image() {
str=$(docker image ls $image)
if [[ "$str" == *"$image"* ]]; then 
 log "Image $image available"
else 
 log "Image $image not available... Abort"
 exit 1
fi
}

#directories to be mounted during tests
host_test_dir=$thisdir
container_test_dir=/test
workspace_host=$thisdir/workspace_host

# Runs docker container with /test mounted and CernVM FS mounted inside
run_docker_inside() {
  docker run --rm -it                      \
  --device /dev/fuse                       \
  --cap-add SYS_ADMIN                      \
  -v $host_test_dir:$container_test_dir:Z  \
  -v $workspace_host:/workspace:Z          \
  $image bash $container_test_dir/src/$1
  
}

# Runs docker container with /test mounted and CernVM FS from host
 run_docker_host() {
  docker run --rm -it                     \
  --device /dev/fuse                      \
  --cap-add SYS_ADMIN                     \
  -v /cvmfs:/cvmfs:ro                     \
  -v $thisdir:/test:Z                     \
  -v $workspace_host:/workspace:Z         \
  $image bash $container_test_dir/src/$1
}

# Mapping testsuite and skipped tests
mapfile -t testsuite < $testsuite
num_tests=${#testsuite[@]}
mapfile -t skip < $skip

# Run the tests
for t in "${testsuite[@]}"
do
  . ./src/$t/main

  # Check CernVM mount specification
  if [[ ! "${tags[*]}" =~ "$cvmfs_mount" ]]; then
    skip+=("$t")
    log "Adding $t to tests to be skipped..." 
  fi

  if [[ "${skip[*]}" =~ "$t" ]]; then
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
