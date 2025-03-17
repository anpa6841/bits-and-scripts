#!/bin/bash

./multipass-create-vm.sh
./multipass-clone.sh ubuntu 2

vms=$(multipass list | awk 'NR>1 {print $1}')

for vm in $vms; do
  ./multipass-configure-ssh.sh $vm
done
