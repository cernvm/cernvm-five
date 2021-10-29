#!/bin/bash
# this script is used to start the testcases in ./test/src/container
usage() {
  echo "$0 </path/to/logfile> <image:version>"
}

logfile=$1
if [ -z $logfile ]; then
  usage
  exit 1
fi

image=${BASH_ARGV[0]}
if [ -z $image ]; then
  usage
  exit 1
fi


# logger
log() {
echo '['$(date +"%D %T %z")']' $1 | tee -a $logfile
}

log "Hostname: $(hostname)"
log "Logfile: $logfile"
log "Image: $image"

# thisdir
SOURCE=${BASH_ARGV[0]}
thisdir=$(cd "$(dirname "${SOURCE}")"; pwd)
thisdir=$(readlink -f ${thisdir})
log "Workingdirectory:"$thisdir

# check podman
podman --version  
if [ $? -ne 0 ]; then
  log "Podman not installed... Abort"
  exit 1
else 
  log "Running $(podman --version)"
fi

# Check image
str=$(podman image ls $image)
if [[ "$str" == *"$image"* ]]; then 
  log "Image $image available"
else 
  log "Image $image not available... Abort"
  exit 1
fi


# tmp
. ./src/container/001-check_LD_LIBRARY_PATH/main 
log "Started $cvm_test_name"
cvm_run_test 