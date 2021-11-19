#!/bin/bash
fail=
apps=("nano" "ping")
for a in "${apps[@]}"
do
  which $a
  if [ $? -eq 0 ]; then
    fail="true"
  fi
done
 
if [[ $fail == "true" ]]; then
    exit 1
fi
exit 0
