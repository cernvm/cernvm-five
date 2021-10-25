#!/bin/bash
# This file is part of CernVM 5.
# Mounting cvmfs
mkdir -p /cvmfs/sft.cern.ch 
mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch

mkdir -p /cvmfs/fcc.cern.ch
mount -t cvmfs fcc.cern.ch /cvmfs/fcc.cern.ch

mkdir -p /cvmfs/cernvm-five.cern.ch
mount -t cvmfs cernvm-five.cern.ch /cvmfs/cernvm-five.cern.ch

mkdir -p /cvmfs/fcc-nightlies.cern.ch
mount -t cvmfs fcc-nightlies.cern.ch /cvmfs/fcc-nightlies.cern.ch