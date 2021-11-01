#!/bin/bash
usage() {
  echo "$0 </path/to/logfile> <image:version> <mount /cvmfs inside -i or from host -h> <testsuite>"
}

logfile=$1
if [ -z $logfile ]; then
  echo "No logfile specified"
  usage
  exit 1
fi

image=$2
if [ -z $image ]; then
  echo "No given image"
  usage
  exit 1
fi

if [ $3 != "-i" ] && [ $3 != "-h" ]; then
  echo "Specify how to mount CernVM FS"
  usage
  exit 1
fi

if [ -z $4 ]; then
  echo "No given testsuite"
  usage
  exit 1
fi

mapfile -t testsuite < $4
num_tests=${#testsuite[@]}
if [ $num_tests -le 0 ]; then
  echo "Zero tests in testsuite $3"
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
log "#Testcases:$num_tests"

# check podman 
podman --version  
if [ $? -ne 0 ]; then
  log "Podman not installed... Abort"
  exit 1
else 
  log "Running $(podman --version)"
fi

# Check image
#str=$(docker image ls $image)
#if [[ "$str" == *"$image"* ]]; then 
#  log "Image $image available"
#else 
#  log "Image $image not available... Abort"
#  exit 1
#fi

#directories to be mounted during tests
host_test_dir=$thisdir
container_test_dir=/test
workspace_host=$thisdir/workspace_host


# check host cvmfs config and run container with /test, /workspace and /cvmfs mounted
if [ $3 == "-h" ]; then
  log "Option -h: Probing host CernVM FS"
  cvmfs_config probe
  if [ $? != "0" ]; then
    log "Probing CernVM FS Client failed... Abort"
    exit 1
  fi

    log "Starting Container and tests..."
  log "--------------------------------"
  podman run --rm -it                \
  --device /dev/fuse                 \
  --cap-add SYS_ADMIN                \
  -v /cvmfs:/cvmfs:ro                \
  -v $thisdir:/test:Z                  \
  -v $workspace_host:/workspace:Z    \
  $image bash $container_test_dir/run.sh $logfile $4
fi

# run container with /test and /workspace mounted
if [ $3 == "-i" ]; then
  log "Option -i: Starting Container and tests..."
  log "------------------------------------------"
  podman run --rm -it             \
  --device /dev/fuse              \
  --cap-add SYS_ADMIN             \
  -v $test_dir:$container_test_dir:Z            \
  -v $workspace_host:/workspace:Z \
  $image $container_test_dir/run.sh $logfile $4
fi
