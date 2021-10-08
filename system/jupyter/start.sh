#!/bin/bash
# This file is part of CernVM 5.
set -e
date
# Mounting cvmfs
bash /init/mount.sh
# Installing the lcg stack
source /cvmfs/sft.cern.ch/lcg/views/LCG_100/x86_64-centos8-gcc10-opt/setup.sh
# Starting a jupyter notebook on port 8888
jupyter-lab --port=8888 --no-browser --ip="0.0.0.0" --core-mode --allow-root
