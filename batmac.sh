#!/bin/bash

# Function to generate a random string
generate_random_string() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c "$1"
}

# List available network interfaces
interfaces=$(ip link show | awk -F': ' '/^[0-9]+: / {print $2}')
echo "Available interfaces: $interfaces"

# User selects a network interface
read -p "Enter the name of the interface you want to configure: " selected_interface

# Input validation for the selected interface
if ! [[ " $interfaces " =~ " $selected_interface " ]]; then
  echo "Invalid interface. Please choose a valid interface."
  exit 1
fi

# Change MAC address for the selected interface (persistent)
new_mac=$(printf '%02x:' $(od -An -N3 -i /dev/random) | sed 's/.$//')

# Use systemd to change the MAC address
sudo systemctl stop NetworkManager   # Stop NetworkManager (or your network service)
sudo ip link set dev "$selected_interface" address "$new_mac"
sudo systemctl start NetworkManager  # Start NetworkManager (or your network service)

# Change hostname
random_hostname=$(generate_random_string $((RANDOM % 7 + 6)))
sudo hostnamectl set-hostname "$random_hostname"

echo "The MAC address of $selected_interface has been changed to $new_mac (persistent)"
echo "The hostname has been set to $random_hostname"