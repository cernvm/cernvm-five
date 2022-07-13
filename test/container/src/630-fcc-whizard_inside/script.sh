#!/bin/bash
set -e
. ./etc/cernvm/cernvm_env.sh
cernvm_config mount -a
cernvm_config setup_systemapps
source source /cvmfs/sw.hsf.org/spackages4/key4hep-stack/release-2021-10-29-ip7764o/x86_64-centos8-gcc8.4.1-opt/setup.sh
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