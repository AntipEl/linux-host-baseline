# Access and Security

## 1. Access matrix
Access permissions apply to both files and directories.

For directories, `X` (execute) allows a user to traverse the directory and access its contents. Directory traversal is required to reach a file located inside it. Without execute permission on any directory in the path, the user cannot access the target file, even if the file itself grants the required permissions.

- `R` - read;
- `W` - write;
- `X` - execute (for directories, allows traversal; for files, allows execution);
- `-` - no permission.

User                    SSH Access      Sudo            Application Files       Configuration       Logs            Application Data
admin       	        SSH key         Full            Full control            RW-                 Full control    Full control
deploy                  SSH key         Limited 	    RWX                     R-X                 R--             R--
appsvc                  no              no              R-X                     R--                 RW-             RW-

## 2. Access Control Principles

**Administrator (`admin`):** Full administrative access to the system and application resources.

**Deployment user (deploy): Limited administrative privileges. The account has read, write, and execute access to application files to perform deployments. It has read-only access to application configuration, logs, and application data. Service management is restricted to explicitly permitted operations.

**Application service account (`appsvc`):** No SSH or sudo access. The account has read and execute permissions for application files, read-only access to application configuration, and read and write permissions for application logs and data as required by the application.

The matrix describes the intended access model. Effective permissions must be verified against the actual account configuration, group memberships, filesystem permissions, ACLs, sudoers rules, and SSH configuration.