#!/bin/bash

# Check if the boxes file exists
if [ ! -f "boxes.txt" ]; then
    echo "Error: boxes.txt file not found!"
    exit 1
fi

# Read each line from boxes.txt and download the box
while IFS= read -r box; do
    if [[ -n "$box" && "$box" != \#* ]]; then
        echo "Downloading Vagrant box: $box"
        vagrant box add --force --provider=libvirt "$box"
    fi
done < boxes.txt
