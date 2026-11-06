# SSH and Access Troubleshooting

## 1. Scope
This document covers troubleshooting SSH connectivity, public-key authentication, and permission errors encountered after login.
- [Access model](docs/access-and-security.md)
- [SSH configuration example](configs/ssh/sshd_config.example)
- [Service operations](docs/service-operations.md)

The procedures below describe how to identify the cause of a failure and apply a targeted fix. They do not replace the access-control policy or the server's actual configuration.

## 2. SSH connection fails

### Symptom 
    ssh -p 22 deploy@app-01
    ssh: connect to host <SERVER_IP> port 22: Connection timed out 

### Possible causes
- Incorrect server IP address or SSH port.
- VM or network interface is unavailable.
- SSH is not listening on the expected address and port.
- Firewall rules or network routing prevent the TCP connection.

### Diagnostics

1. Check the server's current IP addresses and routes:
    ip -br addr
    ip route show.

2. Check the SSH service:
    systemctl status ssh --no-pager

3. Check the actual listening port:
    sudo ss -tlnp

4. From Windows, test TCP connectivity:
    Test-NetConnection <SERVER_IP> -Port 22

### Interpretation and next action

- If the IP address or port is incorrect, correct the SSH command or client configuration.
- If SSH is not listening, inspect the service status and SSH configuration before making changes.
- If TCP connectivity fails, check the listening address, UFW rules, routing, and Hyper-V network configuration.
- If TCP connectivity succeeds but SSH login fails, continue to Section 3.
- A successful ping does not prove that the SSH port is reachable. A failed TCP connection does not, by itself, identify the cause.

## 3. Public-key authentication fails.

### Symptom

The TCP connection reaches the SSH server, but authentication fails. For example:

`Permission denied (publickey).`

The exact message depends on the authentication methods enabled by the server.

### Possible causes

- The client is offering the wrong private key or no expected key.
- The corresponding public key is missing from the target user's authorized_keys.
- The username is incorrect or SSH access is restricted by server configuration.
- Ownership or permissions prevent SSH from accepting the key.
- The server's authentication policy does not allow the attempted method.

### Diagnostic

1. On Windows, inspect the authentication process:
    ssh -vvv -i ~/.ssh/deploy_ed25519 -o IdentitiesOnly=yes -p 17222 deploy@<SERVER_IP>

2. On the server, verify the account and it's home directory:
    getent passwd deploy 

3. Check the effective SSH configuration and relevant access restrictions:
    sudo sshd -T
    sudo cat /etc/ssh/sshd_config

Review included configuration files where applicable. The output of sshd -T shows effective settings, while the configuration search helps locate relevant directives.

4. Inspect the target user's authorized keys and permissions, using the actual home directory returned by getent passwd:
    sudo ls -ld /home/deploy /home/deploy/.ssh
    sudo ls -l /home/deploy/.ssh/authorized_keys
    sudo namei -l /home/deploy/.ssh/authorized_keys
    sudo cat /home/deploy/.ssh/authorized_keys

5. Check SSH logs:

    sudo journalctl -u ssh --since "10 minutes ago" --no-pager

### Interpretation and next action

- If the client offers the wrong key, correct the client command or SSH configuration.
- If the public key is missing or incorrect, install the intended public key for the correct user.
- If ownership or permissions are incorrect, correct only the affected paths.
- if access restrictions exclude the user or authentication method, review the relevant SSH policy before changing it.
- After the fix, establish a new SSH connection and verify that key authentication succeeds.

## 4. Permission Denied After Login

### Symptom

The user can log in over SSH but cannot access a file, directory, or administrative operation.

First identify which operation failed. File access errors and sudo authorization errors have different causes.

### 4.1. File or directory access denied

### Diagnostics

- Check the user's identity and groups:
    id deploy
    groups deploy

- Inspect permissions along the path to the resource:
    namei -l /path_to_file
    ls -l /path_to_file
    getfacl /path_to_file

### Interpretation

- For the example unit file, the owner is root and the permissions are 644. This permits deploy to read the file but not modify it.
- That is normally appropriate: a deployment user should not automatically be able to modify system-level service definitions.

### Next action

- Determine the access required for the intended task. Check ownership, group membership, directory traversal permissions, file permissions, and ACLs.
- Change only the permissions or access mechanism required by the access model. Do not grant write access to a system configuration file merely to resolve a permission error.

### 4.2. Sudo operation denied

### Symptom

A user attempts an administrative operation and receives a sudo authorization error.

### Diagnostics

- As the affected user:
    sudo -l

- As an administrator:

    sudo -l -U deploy
    sudo visudo -c

### Interpretation and next action

- A restricted deploy account may be intentionally prohibited from stopping services or executing arbitrary administrative commands.
- If the operation is not part of the user's role, the denial is expected. If the operation is required, grant only the necessary privilege through an appropriate sudoers rule, then validate the configuration and verify the effective permissions with sudo -l.
- visudo validates and safely edits sudoers configuration; it does not grant permissions by itself.