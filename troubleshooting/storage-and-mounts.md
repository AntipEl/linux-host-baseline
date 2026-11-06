# Storage and mounts

## 1. Scope 
This document covers common storage issues that may prevent an application from accessing its data:
- The expected filesystem is not mounted at /mnt/data-demo.
- The filesystem fails to mount during system boot.
- The application cannot write to /mnt/data-demo/demo-app.

The directory /mnt/data-demo/demo-app is used by the application to store persistent data

## 2. Mount is missing

### Symptom
The application cannot access its data directory because the expected filesystem is not mounted.

### Diagnostic
List available block devices, filesystems, UUIDs, and mount points:
   lsblk -f
Check whether the expected filesystem is mounted:
   findmnt /mnt/data-demo
Check the filesystem configuration:
   cat /etc/fstab
Check available disk space and filesystem type:
   df -h /mnt/data-demo

### Interpretation
- No output from findmnt indicates that the specified mount point is not mounted.
- The device or filesystem may be missing or unavailable.
- The mount point or device reference in /etc/fstab may be incorrect.
- If the filesystem is not mounted, df may show the filesystem containing the parent

## 3. Mount fails during boot

### Symptom
The filesystem is not mounted after the system boots, and the application cannot access its data.

### Diagnostic
Check the UUID and filesystem type:
   sudo blkid <DEVICE_NAME>
Check boot logs for mount-related errors:
   journalctl -b --no-pager | grep -iE 'mount|<mount_point>|UUID|I/O error'
Compare the actual UUID with the entry in /etc/fstab:
   cat /etc/fstab
   sudo blkid <DEVICE_NAME>

### Interpretation
- The UUID in /etc/fstab does not match the actual filesystem UUID.
- The device may not be available when the system attempts to mount it.
- Boot logs may contain errors explaining why the mount operation failed.

## 4. Application cannot write data

### Symptom
The application runs, but fails to create or modify files in its data directory.

### Diagnostic
Check directory ownership and permissions along the path:
   namei -l /mnt/path_to_persistant_storage
Check the owner, group, and permissions of the data directory:
   stat /mnt/path_to_file
Check which user and group the service runs under:
   systemctl cat demo-app.service

### Interpretation
- The service user may not have write permission on the data directory.
- One of the parent directories may prevent the service user from accessing the data directory.
- The directory ownership or permissions may not match the service user and group configured in the systemd unit.