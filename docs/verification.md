# Verification

This document summarizes the checks performed in the `app-01` environment.

## Verified

- **Access:** SSH key authentication and configured user permissions.
- **Service:** systemd lifecycle, restart behavior, and application health endpoint.
- **Storage:** separate data filesystem, UUID-based mount, and persistence after reboot.
- **Logging:** systemd journal, application logs, and log rotation.
- **Network:** DNS resolution, listening ports, UFW rules, and host connectivity.

## Connectivity Results

- SSH on port `22`: verified from the Windows host.
- HTTP on port `80` through Nginx: verified from the Windows host.
- Application on port `8080`: listening; remote connectivity not confirmed.
- HTTPS on port `443`: UFW allows traffic, but an HTTPS listener and successful TLS connection have not been verified.

## Scope

Checks were performed in a local Ubuntu Server VM under Hyper-V. These results describe the lab environment and do not establish production readiness.