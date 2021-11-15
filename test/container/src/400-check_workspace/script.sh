#!/bin/bash
res=0

# Read
if ! cat /workspace/test.sh; then
    res=1
fi


# Write into container
if ! cp /workspace/test.sh /; then
    res=1
fi


# Excecute in Container
if ! bash /workspace/test.sh; then
    res=1
fi


# Writing to host
if ! echo "Test" >> /workspace/test.txt; then
    res=1
fi



if [ $res -ne 0 ]; then
    exit 1
fi

exit $res