Change and recovery

## 1. Purpose and scope
This document describes a safe procedure for making, verifying, and reverting server configuration changes. It covers systemd units, SSH, firewall rules, application settings, storage mounts, scheduled tasks, log rotation, and software changes that affect system services.

## 2. Before a change
Record the current system state:
   systemctl is-active <service_name_1> <service_name_2>
   systemctl --failed
Check server connectivity from a Linux client:
   nc -vz -w 5 <SERVER_IP> <PORT>
   ping -c 4 <SERVER_IP>
Check SSH connectivity from a Windows:
   Test-NetConnection <SERVER_IP> -Port <PORT>
Create a backup of the configuration file before editing it:
   sudo cp -a /etc/path-to-has-been-changed-file "/etc/path-to-has-been-changed-file.bak.$(date +%F-%H%M%S)"
For high-risk changes, create a VM snapshot if available.

## 3. Apply and validate
Edit only the required configuration:
   sudo nano /etc/path-to-config
Check the configuration syntax, if the service provides a validation command. Refer to the service documentation for the appropriate command.
For systemd unit file changes only:
   sudo systemctl daemon-reload
Apply the changes using the appropriate service command:
   sudo systemctl restart <service_name>

## 4. Verify the result
Check the service status:
   systemctl status <service_name> --no-pager
Check listening TCP ports:
   sudo ss -tlnp
Test the application endpoint:
   curl -i http://<BIND>:<PORT>/health
Check service logs:
   journalctl -b -u <service_name> --no-pager
Verify that other affected services are still active:
   systemctl is-active <service_name_1> <service_name_2>
Check recent log messages if necessary:
   journalctl -b -u <service_name> --since "10 minutes ago"

## 5. Rollback
Identify the conditions that indicate the change was unsuccessful.
Restore the previous configuration from the backup:
   sudo cp -a /etc/path-to-config.bak.TIMESTAMP /etc/path-to-config
Reapply the restored configuration where required and verify the service. Examples:
   systemd unit:
      sudo systemctl daemon-reload.
      sudo systemctl restart <service_name>.
   Nginx:
      sudo nginx -t
      sudo systemctl reload nginx
   fstab:
      sudo mount -a.
   SHH:
      Validate the SSH configuration before applying it.
      Keep the current SSH session open.
      Test a new SSH connection before closing the existing session.
   UFW:
      Restore the previous firewall rules if the change caused connectivity issues.
      Keep the current SSH session open and verify a new connection before closing it.
If the normal rollback does not restore the system, consider restoring a VM snapshot. Be aware that this also reverts other VM changes made after the snapshot was created.


## 6. Reboot recovery
Check whether the service is enabled at boot:
   systemctl is-enabled <service_name>
Check the service status after reboot:
   systemctl status <service_name> --no-pager
If the service is not enabled but should start automatically:
   systemctl enable <service_name>
If the service is inactive, investigate the cause before attempting to start it manually.
Check required mount points:
   findmnt /mnt/<mount_point>
Verify application availability after reboot.
   On a Linux client or locally on the server:
      curl -i http://<BIND>:<PORT>/health
   From Windows, check SSH connectivity:
      Test-NetConnection <SERVER_IP> -Port <PORT>
Ensure that services and filesystems start automatically after reboot without requiring manual intervention.

## 7. Change record
Briefly record the change, its reason, the validation result, and the rollback method. Example:
   Date: 2026-11-04
   Component: <service_name>
   Reason: Update service restart settings
   Change: Changed RestartSec from 10 to 5
   Validation: Service restarted successfully; /health returned HTTP 200
   Result: Successful
   Rollback: Restore previous demo-app.service backup
Git history can be used to track changes made to repository files.