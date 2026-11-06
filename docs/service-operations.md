# Service Operations

## 1. Overview

`demo-app` is managed by systemd and runs under the dedicated `appsvc` service account.

Component               Path or value                               Purpose
Application files       `/srv/demo-app`                             Application code
systemd unit            `/etc/systemd/system/demo-app.service`      Service definition
Environment file        `/etc/demo-app/app-01.env`                  Application configuration
Persistent data         `/mnt/data-demo/demo-app`                   Application data
File logs               `/var/log/demo-app`                         Additional application logs
Service account         `appsvc`                                    Application process identity
Application port        `8080`                                      HTTP endpoint

## 2. Service Management

### Check service status:

sudo systemctl status demo-app.service --no-pager


### Start, stop, or restart the service:

sudo systemctl start demo-app.service
sudo systemctl stop demo-app.service
sudo systemctl restart demo-app.service

### Check whether the service is enabled at boot and inspect its configuration:

sudo systemctl is-enabled demo-app.service
sudo systemctl cat demo-app.service

## 3. Health Checks and Troubleshooting

### Check the local HTTP health endpoint:

curl -i http://BIND_ADDR:PORT/health

Replace the placeholders with the application's bind address, listening port, and health endpoint path.

For a local check, use 127.0.0.1 as the address when the application accepts connections on loopback.
A successful response should match the application's expected health status and response body. For this lab, the expected response is HTTP `200` with `ok`.
These checks cover different layers: systemd reports service state, `ss` shows listening sockets, and `curl` tests the HTTP endpoint.

## 4. Logs

The systemd journal stores the service's standard output and standard error.

### View logs from the current boot:

sudo journalctl -b -u demo-app.service --no-pager

Additional application file logs are stored under `/var/log/demo-app` and are managed through log rotation.

### View the last five lines of the application log:

tail -n 5 /var/log/demo-app/app-01.log

## 5. Storage Check

Application data is stored on a separate filesystem mounted at `/mnt/data-demo/`.

Verify the mount:

findmnt /mnt/data-demo

The service depends on the required data mount. Its configuration should be checked to confirm that the service cannot start normally when that mount is unavailable.