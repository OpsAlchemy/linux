#!/bin/bash

PUBLIC_IP=$(terraform output -raw public_ip)

PRIVATE_KEY="/tmp/private_key.pem"

USERNAME="azureuser"

ssh -i "$PRIVATE_KEY" "$USERNAME@$PUBLIC_IP"