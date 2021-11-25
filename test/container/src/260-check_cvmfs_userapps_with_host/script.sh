#!/bin/bash
. ./etc/cernvm/functions
cernvm_config setup_platform

fail=
apps=("nano" "vim" "http_ping")
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
