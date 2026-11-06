# Network and Connectivity

## 1. Network Interfaces

The server has a loopback interface and a network interface connected to the configured network.

Component           Observed value      State
Loopback            `127.0.0.1/8`       `UNKNOWN`
Network interface   `eth0`              `UP`
IPv4 address        `<SERVER_IP>`       Observed at the time of inspection

The server's IPv4 address may change because it is dynamically assigned.

## 2. Routing and DNS

The server uses `systemd-resolved` for local DNS resolution.

The following local resolver addresses were observed:

- `127.0.0.53:53`
- `127.0.0.54:53`

The network interface `eth0` has a UDP socket on port `68`, used for DHCP client communication.

## 3. Listening Sockets

The following sockets were observed in the output of `ss -tulnp`.

### 3.1. UDP

Local address       Port        Process
`127.0.0.1`         `323`       `chronyd`
`127.0.0.54`        `53`        `systemd-resolved`
`127.0.0.53%lo`     `53`        `systemd-resolved`
`<SERVER_IP>%eth0`  `68`        `systemd-networkd`
`[::1]`             `323`       `chronyd`

### 3.2. TCP

Local address       Port        Process
`127.0.0.54`        `53`        `systemd-resolved`
`127.0.0.53%lo`     `53`        `systemd-resolved`
`0.0.0.0`           `8080`      `python3`
`0.0.0.0`           `22`        `sshd`
`[::]`              `22`        `sshd`
`0.0.0.0`           `80`        `nginx`
`[::]`              `80`        `nginx`

The listening addresses `0.0.0.0` and `[::]` indicate that the respective processes listen on all local IPv4 and IPv6 addresses, respectively.

No TCP listener on port `443` was present in the observed output.

## 4. Firewall Configuration

UFW is active with the following default policies:

Setting                 Value
Logging                 Low
Incoming traffic        Deny
Outgoing traffic        Allow
Routed traffic          Disabled

The following incoming TCP ports are allowed from any source:

Port            Intended purpose        Firewall action
`22/tcp`        SSH                     Allow
`80/tcp`        HTTP                    Allow
`443/tcp`       HTTPS                   Allow

The rules apply to IPv4 and IPv6.

## 5. HTTP, HTTPS, and Nginx

Nginx is installed, running, and listening on port `80` on all local IPv4 and IPv6 addresses.

A separate `python3` process is listening on port `8080` on all local IPv4 addresses.

The current socket information does not establish whether Nginx forwards requests to the application on port `8080`. The reverse proxy configuration has not yet been verified.

UFW allows incoming traffic on port `443`, but no process was observed listening on that port. HTTPS and TLS are therefore not yet confirmed as operational.

### Planned Work

- Review and document the Nginx configuration.
- Define the Nginx access policy and configure the intended reverse proxy behavior.
- Verify request forwarding from Nginx to the application on port `8080`.
- Configure HTTPS and TLS.
- Test HTTP and HTTPS responses from the Windows host.