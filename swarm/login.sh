#!/bin/bash

KEYS_DIR="$HOME/swarm/keys"
PUBLIC_IP_FILE="./swarm/public-ip.json"

if [ -z "$1" ]; then
  echo "Usage: $0 <vm_name>"
  echo "Example: $0 helium"
  exit 1
fi

VM_NAME=$1

if [ ! -f "$PUBLIC_IP_FILE" ]; then
  echo "Error: Public IP file ($PUBLIC_IP_FILE) not found."
  exit 1
fi

IP_ADDRESS=$(jq -r --arg vm_name "$VM_NAME" '.[$vm_name] | to_entries[0].value.ip_address' "$PUBLIC_IP_FILE")

if [ -z "$IP_ADDRESS" ] || [ "$IP_ADDRESS" == "null" ]; then
  echo "Error: Unable to find IP address for VM '$VM_NAME'."
  exit 1
fi

PEM_FILE="$KEYS_DIR/$VM_NAME.pem"
if [ ! -f "$PEM_FILE" ]; then
  echo "Error: PEM file ($PEM_FILE) not found."
  exit 1
fi

echo "Connecting to $VM_NAME at $IP_ADDRESS..."
ssh -i "$PEM_FILE" azureuser@"$IP_ADDRESS"
