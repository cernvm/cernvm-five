#!/bin/bash
# This file is part of CernVM 5.
# Mounting cvmfs
mkdir -p /cvmfs/sft.cern.ch 
mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch
