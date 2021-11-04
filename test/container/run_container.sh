#!/bin/bash
usage() {
  echo "$0 </path/to/logfile> <image:version> <mount /cvmfs inside -i or from host -h> <testsuite> <skip>"
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

# mapfile -t testsuite < $4
# num_tests=${#testsuite[@]}
# if [ $num_tests -le 0 ]; then
#   echo "Zero tests in testsuite $3"
#   exit 1
# fi

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


# check docker 
docker --version  
if [ $? -ne 0 ]; then
  log "docker not installed... Abort"
  exit 1
else 
  log "Running $(docker --version)"
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
if [ $cvmfs_mount == "-h" ]; then
  log "Option -h: Probing host CernVM FS"
  cvmfs_config probe
  if [ $cvmfs_mount != "0" ]; then
    log "Probing CernVM FS Client failed... Abort"
    exit 1
  fi

  log "Starting Container and tests..."
  log "--------------------------------"
  docker run --rm -it                \
  --device /dev/fuse                 \
  --cap-add SYS_ADMIN                \
  -v /cvmfs:/cvmfs:ro                \
  -v $thisdir:/test:Z                  \
  -v $workspace_host:/workspace:Z    \
  $image bash $container_test_dir/run.sh $logfile $4
fi

# run container with /test and /workspace mounted
if [ $cvmfs_mount == "-i" ]; then
  log "Option -i: Starting Container and tests..."
  log "------------------------------------------"
  docker run --rm -it             \
  --device /dev/fuse              \
  --cap-add SYS_ADMIN             \
  -v $host_test_dir:$container_test_dir:Z            \
  -v $workspace_host:/workspace:Z \
  $image $container_test_dir/run.sh $logfile $cvmfs_mount $testsuite $skip
fi
