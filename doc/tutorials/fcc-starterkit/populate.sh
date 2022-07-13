#!/bin/bash
. /etc/cernvm/cernvm_env.sh
cernvm_config mount -s
mkdir /cvmfs/fcc.cern.ch /cvmfs/sw-nightlies.hsf.org /cvmfs/sw.hsf.org
mount -t cvmfs  fcc.cern.ch /cvmfs/fcc.cern.ch
mount -t cvmfs  sw-nightlies.hsf.org /cvmfs/sw-nightlies.hsf.org
mount -t cvmfs  sw.hsf.org /cvmfs/sw.hsf.org

pwd
ls
git clone https://github.com/hep-fcc/fccanalyses
cd fccanalyses/
mkdir build
cd build
cmake ..
make && make test

cd /
rm -r -f /populate