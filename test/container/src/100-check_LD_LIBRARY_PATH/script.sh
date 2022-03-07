#!/bin/bash
if [[  "$LD_LIBRARY_PATH" != "" ]]; then
  exit 1
fi
echo $LD_LIBRARY_PATH
echo "RAAAAAAAAAAAAAAAAAAAAAAN"
exit 0