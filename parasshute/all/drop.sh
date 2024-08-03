#!/bin/bash
# parasshute/all/drop.sh

echo $PWD
# Iterate over all directories except "all"
for dir in $(ls -d */ | grep -v "all/"); do
    $dir/drop.sh
done
