#!/bin/bash
set -e
date
#mounting cvmfs
bash /init/mount.sh
source /cvmfs/sft.cern.ch/lcg/views/LCG_100/x86_64-centos8-gcc10-opt/setup.sh
jupyter-lab --port=8888 --no-browser --ip="0.0.0.0" --core-mode --allow-root
