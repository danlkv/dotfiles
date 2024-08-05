#!/bin/bash
# parasshute/all/drop.sh

echo $PWD
# Iterate over all directories except "all"
for file in $(ls */drop.sh | grep -v "all/"); do
    $file
done
