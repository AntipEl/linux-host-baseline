# Service failures

## 1. Scope
This document covers common situations in which an application or its systemd service fails:
- fails to start
- stops unexpectedly during operation
- becomes unresponsive

## 2. Service Startup Failure

### Symptom
The service exits during startup and does not reach the active state.

### Diagnostics
Check the service status:
    systemctl status demo-app.service --no-pager
Check the service logs from the current boot:
    journalctl -b -u demo-app.service --no-pager
Check the service unit configuration:
    systemctl cat demo-app.service

### Interpretation

- The service may fail due to an invalid unit configuration, incorrect paths, or missing dependencies.
- Permission errors may indicate that the service user cannot access required files or directories.

## 3. Application Endpoint Unavailable

### Symptom

The service is running, but requests to the application endpoint fail or return unexpected responses.

### Diagnostics
Check the application PID and listening TCP sockets:
    sudo ss -ltnp
Check whether the application responds locally:
    curl -i http://127.0.0.1:8080/health
Check the bind address, port, and environment file path in the service configuration:
    systemctl cat demo-app.service

### Interpretation
- The application may be listening on a different address or port.
- The endpoint may be unavailable even though the service process is running.
- Incorrect environment variables may prevent the application from responding as expected.

## 4. Repeated Service Restarts

### Symptom

The service enters a restart cycle, repeatedly stopping and starting without remaining active.

### Diagnostics
Check the journal around the time of the failure:
    journalctl -u <app_name> --since "time around error"
Check for startup errors and mount-related dependency failures:
    journalctl -u <app_name> -b -p err --no-pager
    cat /etc/path_to_file.env
Check the restart policy and delay:
     sudo cat /etc/systemd/system/app_name.service

### Interpretation
- The application process may exit or crash, causing systemd to restart it.
- A missing dependency or unavailable mount may prevent the service from starting successfully.
- The Restart= and RestartSec= settings define how systemd handles service restarts.