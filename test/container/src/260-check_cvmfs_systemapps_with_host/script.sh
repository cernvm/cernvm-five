#!/bin/bash
. ./etc/cernvm/functions
. ./etc/cernvm/systemapps
cernvm_config setup_systemapps

fail=
for a in "${apps[@]}"
do
  which $a
  if [ $? -ne 0 ]; then
    fail="true"
  fi
done
 
if [[ $fail == "true" ]]; then
    exit 1
fi
exit 0
