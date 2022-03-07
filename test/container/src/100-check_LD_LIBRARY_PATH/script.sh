#!/bin/bash
if [[  "$LD_LIBRARY_PATH" != "" ]]; then
  exit 1
fi

exit 0