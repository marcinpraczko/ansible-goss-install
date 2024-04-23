#!/usr/bin/env bash

# Install required packages
echo "-------------------------"
echo "--- Install packages  ---"
echo "-------------------------"

apt -y update
apt -y install ansible make
