#!/bin/bash
. ./etc/cernvm/functions
cernvm_config mount_cvmfs -a
set -e
#todo: CentOS 8 build 
cernvm_config setup_platform
source /cvmfs/sw-nightlies.hsf.org/key4hep/setup.sh
mkdir -p test_whizard/Z_mumu; cd test_whizard/Z_mumu
wget https://fccsw.web.cern.ch/fccsw/share/gen/whizard/Zpole/Z_mumu.sin
whizard Z_mumu.sin
res=$? 
if [ $res != "0" ]; then
  exit 1
fi

if [ ! -f z_mumu.lhe ]; then
  exit 1
fi

exit 0