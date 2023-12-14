#!/usr/bin/env python3
import subprocess
import random
import string

# Function to generate a random string
def generate_random_string(length):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

# Function to list available network interfaces
def list_interfaces():
    result = subprocess.run(['ip', 'link', 'show'], capture_output=True, text=True)
    interfaces = []

    for line in result.stdout.splitlines():
        if 'link' in line:
            parts = line.split()
            if len(parts) >= 2:
                interface_name = parts[1].strip(':')
                interfaces.append(interface_name)

    return interfaces

# Function to change MAC address for the selected interface (persistent)
def change_mac_address(interface):
    new_mac = ':'.join(['%02x' % random.randint(0, 255) for _ in range(6)])
    subprocess.run(['sudo', 'ip', 'link', 'set', 'dev', interface, 'address', new_mac])
    print(f"The MAC address of {interface} has been changed to {new_mac} (persistent)")

# Function to change hostname
def change_hostname():
    random_hostname = generate_random_string(random.randint(6, 12))
    subprocess.run(['sudo', 'hostnamectl', 'set-hostname', random_hostname])
    print(f"The hostname has been set to {random_hostname}")

# Main function
def main():
    # List available network interfaces
    interfaces = list_interfaces()
    print("Available interfaces:")
    for i, interface in enumerate(interfaces, start=1):
        print(f"{i}: {interface}")

    # User selects a network interface
    try:
        selected_interface_index = int(input("Enter the number of the interface you want to configure: "))
        selected_interface = interfaces[selected_interface_index - 1]
    except (ValueError, IndexError):
        print("Invalid interface number. Please choose a valid number.")
        exit(1)

    # Change MAC address for the selected interface (persistent)
    change_mac_address(selected_interface)

    # Change hostname
    change_hostname()

if __name__ == "__main__":
    main()
