#!/bin/bash

echo "Files to link here:\n $(cat includes.txt)"

while read card; do
    ln -f ~/$card .
done < includes.txt
