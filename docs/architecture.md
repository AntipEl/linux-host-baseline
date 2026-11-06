# Architecture

## 1. Overview

The project documents the architecture of an Ubuntu Server environment running an application. It covers administrative access, user roles, application components, systemd service management, persistent storage, and network access control.

## 2. System Components

### 2.1. Ubuntu Server

- **Hostname:** `app-01`
- **Administrative access:** SSH using a private key
- **Firewall:** UFW

The administrator connects to the server over SSH. Incoming network traffic is filtered by the firewall according to its configured rules.

### 2.2. Users and Access Roles

The server has user accounts and groups intended to provide access to the required system components.

Role                    Account
Administrator           `admin`
Developer               `deploy`
Application service     `appsvc`

Access permissions are managed separately for the relevant users, groups, and system resources.

### 2.3. Application

The demo application uses the following filesystem locations:

Component             Path
Application file    `/srv/demo-app`
Application logs    `/var/log/demo-app/`
Application data    `/mnt/data-demo/demo-app`

The application runs under the `appsvc` service account.

### 2.4. Service Management

The application is managed by systemd.

- **Service unit directory:** `/etc/systemd/system`
- **Execution account:** `appsvc`

Systemd is responsible for managing the application service lifecycle.

### 2.5. Persistent Storage

Application data is stored in `/mnt/data-demo/demo-app`, located on a separately mounted data disk.

This separates application data from the system filesystem.

### 2.6. Network Access and Firewall

UFW is enabled and configured with the following default policies:

Policy                  Setting
Incoming traffic        Deny
Outgoing traffic        Allow
Routed traffic          Disabled
Logging                 Low

The following incoming TCP ports are allowed from any source:

Port        Purpose
`22`        SSH
`80`        HTTP
`443`       HTTPS

The rules apply to both IPv4 and IPv6.

Nginx listens on port `80`, and the Python application listens on port `8080`. Reverse proxy forwarding from Nginx to the application has not yet been verified. No listener on port `443` was observed, so HTTPS is not confirmed as operational.

## 3. Component Relationships

The main relationships between the system components are:

1. The administrator connects to `app-01` using SSH and a private key.
2. UFW filters incoming network traffic according to its rules.
3. The application runs as the `appsvc` user and is managed by systemd.
4. Application files, logs, and data are stored in their designated filesystem locations.
5. Application data is written to the separately mounted data disk.
6. The application handles requests on ports 8080.

## 4. Architecture Scope

This document describes the current system components and their relationships. Detailed user permissions, service operations, network verification, and troubleshooting procedures are documented separately.