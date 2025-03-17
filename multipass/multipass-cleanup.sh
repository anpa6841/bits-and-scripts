#!/bin/bash

echo "Stopping all VMs..."
multipass stop --all

echo "Deleting all VMs..."
multipass delete --all

echo "Purging deleted VMs..."
multipass purge

echo "All VMs stopped, deleted, and purged."
multipass list

