#!/bin/bash

# Exit on error
set -e

VM_NAME=${1:-"ubuntu"}

# Generate a new SSH key pair
echo "Generating a new SSH key pair..."
SSH_KEY_PATH="$HOME/.ssh/${VM_NAME}_key"
yes y | ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "Multipass VMs key"
echo "SSH key pair generated at $SSH_KEY_PATH"

# Set up SSH keys for each VM
echo "Setting up SSH access..."

multipass exec "$VM_NAME" -- mkdir -p /home/ubuntu/.ssh
multipass transfer "$SSH_KEY_PATH.pub" "$VM_NAME":/home/ubuntu/pubkey.tmp
multipass exec "$VM_NAME" -- bash -c "cat ~/pubkey.tmp >> ~/.ssh/authorized_keys && rm ~/pubkey.tmp"
multipass exec "$VM_NAME" -- bash -c "chmod 700 ~/.ssh"
multipass exec "$VM_NAME" -- bash -c "chmod 600 ~/.ssh/authorized_keys"

# Get IP address
VM_IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
echo "VM $VM_NAME is ready at $VM_IP"
echo "Connect using: ssh -i $SSH_KEY_PATH ubuntu@$VM_IP"

# Create SSH config entries
echo "Creating SSH config entries...."

SSH_CONFIG="$HOME/.ssh/config"

# Backup existing config
if [ -f "$SSH_CONFIG" ]; then
    cp "$SSH_CONFIG" "$SSH_CONFIG.bak"
    echo "Backed up existing SSH config to $SSH_CONFIG.bak"
fi

# Add entries to SSH config
echo -e "\n# Multipass VM entries - added $(date)" >> "$SSH_CONFIG"
VM_IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
echo -e "Host $VM_NAME\n  HostName $VM_IP\n  User ubuntu\n  IdentityFile $SSH_KEY_PATH\n" >> "$SSH_CONFIG"

echo "=== Setup complete ==="
echo "You can now connect to the VMs with:"
echo "  ssh $VM_NAME"
echo ""
echo "VM details:"
multipass list
