#!/bin/bash

# Function to generate a random string
generate_random_string() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c $1 ; echo ''
}

# List available network interfaces
echo "Available interfaces: $(ip link show)"

# User selects a network interface
read -p "Enter the name of the interface you want to configure: " selected_interface

# Input validation for the selected interface WIP

# Change MAC address for the selected interface (persistent)
new_mac=$(printf '%02x:' $(od -An -N3 -i /dev/random) | sed 's/.$//')
[USE SYSTEMD TO CHANGE THE MAC ADDRESS PLS BRINGING DOWN IF AND EDITING AND BRINGING UP IF ETC]

# Change hostname
random_hostname=$(generate_random_string $((RANDOM % 7 + 6)))
sudo hostnamectl set-hostname $random_hostname

echo "The MAC address of $selected_interface has been changed to $new_mac (persistent)"
echo "The hostname has been set to $random_hostname"
