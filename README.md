# Linux Server Baseline

## Project Overview

Linux Server Baseline is an infrastructure project focused on setting up, securing, and maintaining a Linux server for hosting applications. The project covers host configuration, access control, application lifecycle management, secure data storage, network security, and service recovery.

## Architecture

The project uses an Ubuntu Server host named `web-01`.

The server is designed to provide:

- Administrative and deployment access.
- A dedicated service account for running the application.
- Secure storage of application data.
- Service management with systemd and centralized logging through the system journal.
- Controlled network access to HTTP/HTTPS services.
- Documented verification and recovery procedures.

The Git repository contains documentation, configuration examples, operational scripts, and troubleshooting guides. Secrets and sensitive configuration are kept out of the repository.

## Areas of Work

### 1. Host Setup and Access Management

Prepare an Ubuntu Server host with controlled access and clearly separated user privileges.

Scope:

- Separate administrative, deployment, and service accounts.
- SSH key-based authentication and restricted privileges.
- Filesystem layout and access permissions.
- A dedicated data disk mounted by UUID.
- Secure configuration and recovery procedures.

### 2. Application Operations

Run the application as a managed system service.

Scope:

- Separate application files, configuration, logs, and persistent data.
- Run the application under a dedicated service account.
- Configure systemd startup and service restart policies.
- Use the system journal for service logs.
- Configure log rotation for application log files.

### 3. Networking and Security

Control network access to the server and the application it hosts.

Scope:

- Document IP addressing, routing, DNS, listening ports, and firewall rules.
- Restrict SSH access to the administrator's IP address or VPN subnet.
- Configure inbound TCP access according to the required port policy.
- Document troubleshooting procedures for SSH and HTTP/HTTPS connectivity.

HTTP and HTTPS traffic are handled according to the defined network policy. HTTPS requires a valid TLS configuration on the service or reverse proxy handling the connection.

### 4. Containerization and Test Environment

Planned extension: deploy Docker and set up an isolated environment for application testing.

Implementation details and technical documentation will be added as this part of the project develops.

## Verification

Configuration changes are considered verified only after the relevant tests have been run on the server.

Verification covers:

- Access control and privilege restrictions.
- Application startup, failure handling, and recovery.
- Data persistence and behavior after reboot.
- Listening ports and firewall enforcement.
- DNS resolution, gateway reachability, and network connectivity.
- HTTP/HTTPS endpoint availability and, where configured, TLS.
- Deliberately introduced failures and successful recovery.

Actual test results and known limitations are documented separately from expected outcomes.

## Documentation

- [Architecture](docs/architecture.md)
- [Environment](docs/environment.md)
- [Access and Security](docs/access-and-security.md)
- [Network and Connectivity](docs/network-and-connectivity.md)
- [Service Operations](docs/service-operations.md)
- [Verification](docs/verification.md)
- [Access and SSH Troubleshooting](troubleshooting/access-and-ssh.md)
- [Service Failure Troubleshooting](troubleshooting/service-failures.md)
- [Storage and Mount Recovery](troubleshooting/storage-and-mounts.md)
- [Network and HTTP Troubleshooting](troubleshooting/network-and-http.md)
- [Change and Recovery Procedures](operations/change-and-recovery.md)

## Project Status

In progress. Work is being implemented, tested, and documented in stages.