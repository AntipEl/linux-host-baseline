# Target environment

## Operating System
OS:             Ubuntu Server 
Version:        26.04.1 LTS
hostname:       app-01
Architecture:   x86_64

## Compute Resources
Logical CPUs:       6
Available memory:   1.5 GiB
Swap:               2.4 GiB

Values reflect the guest OS at the time of inspection.

## Storage
Device	                    Size	    Filesystem / type           	    Mount point	Purpose
/dev/sda	                12 GB	    ext4 /mnt/data-demo/         	    Persistent application data
/dev/sdb2	                2 GB	    ext4 /boot	                        Boot files
/dev/sdb3	                125 GB	    LVM2 physical volume	            LVM physical volume
/dev/ubuntu-vg/ubuntu-lv	62.5 GB	    ext4 /Root                          filesystem

The system disk uses LVM for the root filesystem. Application data is stored on a separate disk.

## Networking
Loopback:           127.0.0.1/8
Interface:          eth0
IPv4 address:       <SERVER_IP>
Address assignment: Dynamic


# Server environmen
Host OS:    Windows 11
Hypervisor: Hyper-V
Guest:      Ubuntu Server VM app-01
Network:    Virtual network configured through Hyper-V
WSL2:       Not used for the checks documented here