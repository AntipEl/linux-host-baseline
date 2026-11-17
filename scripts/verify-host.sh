#!/bin/bash


# Check hostname
if ! hostname_name=$(hostname) || [[ -z "$hostname_name" ]]; then
    echo "ERROR: Unable to determine hostname"
    exit 1
fi

# Check operating system information
if ! os_name=$(. /etc/os-release && echo "$PRETTY_NAME") || [[ -z "$os_name" ]]; then
    echo "ERROR: Unable to determine operating system"
    exit 1
fi

# Check network interfaces
if ! network_interfaces=$(ip -br addr) || [[ -z "$network_interfaces" ]]; then
    echo "ERROR: Unable to retrieve network interface information"
    exit 1
fi

echo "===================================="
echo "======== Server Information ========"
echo "===================================="

echo
echo "Hostname: $(hostnamectl --static)"
echo "Current server: $(hostname)"
echo "OS: $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Kernel: $(uname -r)"

echo
echo "Uptime: $(uptime)"

echo
echo "CPU:"
lscpu | grep -E '^(Architecture|CPU\(s\)|Model name):'

echo
echo "Memory: $(free -h)"

echo
echo "Block devices:"
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINTS

echo
echo "Mounted filesystems: $(findmnt)"

echo
echo "Network interfaces: $(ip -br addr)"

echo
echo "Time and timezone: $(timedatectl)"

exit 0