#!/bin/bash
# todo: fix test
fail="false"
apps=("nano", "ping")
for a in "${apps[@]}"
do
  which $a
  if [ $? == "0" ]; then
    fail="true"
  fi
done
 
if [ $fail == "true" ]; then
    exit 1
fi
exit 0