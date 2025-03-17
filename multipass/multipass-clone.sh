#!/bin/bash

# Check for two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <original-instance> <num-of-cloned-instances>"
    exit 1
fi

# Assign arguments to variables
ORIGINAL_INSTANCE=$1
NUM_OF_CLONED_INSTANCES=$2
CLONED_INSTANCE=""

# Check if the original instance exists
if ! multipass list | grep -q "^$ORIGINAL_INSTANCE "; then
  echo "Error: Instance '$ORIGINAL_INSTANCE' does not exist."
  exit 1
fi

# Stop the original instance
if multipass info "$ORIGINAL_INSTANCE" | awk -F ': ' '/State/ {print $2}' | grep -q "Running"; then
  echo "Stopping '$ORIGINAL_INSTANCE'..."
  multipass stop "$ORIGINAL_INSTANCE"
  sleep 5 
fi

for i in $(seq 1 "$NUM_OF_CLONED_INSTANCES"); do
  cloned_instance=$(multipass clone $ORIGINAL_INSTANCE | awk '/Cloned from/ { sub(/\.$/, "", $NF); print $NF }')
  echo "Starting cloned instance $cloned_instance..."
  multipass start $cloned_instance
done

# Restart the original instance
echo "Restarting '$ORIGINAL_INSTANCE'..."
multipass start "$ORIGINAL_INSTANCE"
