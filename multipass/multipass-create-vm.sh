#!/bin/bash

# Exit on error
set -e

VM_NAME="ubuntu"

# Launch VM
(timeout 45s multipass launch lts --name $VM_NAME --memory 2G --disk 10G && echo "$VM_NAME launched successfully.") &

# Wait for background processes to finish
wait

multipass exec $VM_NAME -- sudo bash -c "apt install -y build-essential curl wget git vim net-tools openssh-server"

