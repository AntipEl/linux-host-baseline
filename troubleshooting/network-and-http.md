# Network and http

## 1. Scope
This document helps identify the stage at which a problem occurs when connecting to the server or its services:
- Network interfaces and routing
- TCP connections
- HTTP

## 2. Server address is unavailable or changed

### Symptom
The server cannot be reached using the expected IP address.

### Diagnostic
Check the IP address and network interface used for the connection on the VM:
   ip -br addr
Check the routing path:
   ip route get <CLIENT_IP>
Check the current server IP address from Windows:
   Test-NetConnection <SERVER_IP> -Port <PORT>

### Interpretation
- The client is using an outdated or incorrect server IP address.
- The expected network interface or IP address is missing on the server.
- The route to the server is missing or incorrectly configured.
- The server is unreachable from the client network. 

## 3. TCP connection fails

### Symptom
The server is reachable by IP, but a TCP connection to the expected port cannot be established.

### Diagnostic
Check whether the service is listening on the expected TCP port:
   ss -ltnp
Check whether the firewall policy allows incoming connections to the port being investigated:
   sudo ufw status verbose
Check connectivity to the port from an external environment, in this case, from Windows:
   Test-NetConnection <SERVER_IP> -Port <PORT>

### Interpretation
- No process is listening on the expected port.
- The firewall blocks the incoming connection.
- The TCP connection fails due to routing issues or external network restrictions.

## 4. HTTP endpoint fails

### Symptom
The TCP connection is established, but the HTTP endpoint does not return the expected response.

### Diagnostic

Check application availability locally on the server:
   curl -i http://127.0.0.1:8080/health
Check the Nginx TCP port from Windows:
   Test-NetConnection <SERVER_IP> -Port 80
Check the HTTP response from Nginx using Windows:
   curl.exe -i http://<SERVER_IP>/

### Interpretation
- UFW allows incoming connections on port 80, but this alone does not confirm HTTP availability.
- Nginx does not accept the connection or returns an HTTP error.
- The local application does not respond to the HTTP request.
- If Nginx responds but the application is unavailable through it, the reverse proxy configuration must be checked.

## 5. HTTPS fails

### Symptom
An HTTPS connection cannot be established or the server does not return the expected HTTPS response.

### Diagnostic
Check for a listener on port 443:
   ss -tulnp | grep ':443'
Проверить Check the syntax of the Nginx configuration:
   sudo nginx -t
Check the TLS connection:
   openssl s_client -connect <SERVER_IP>:443

### Interpretation
- No listener is present on TCP port 443.
- The Nginx configuration contains an error or HTTPS is not configured.
- The TLS handshake fails, for example, due to certificate or TLS configuration issues.
- An allowed port 443 in UFW does not mean that HTTPS is configured and working.