# Access and Security

## 1. Access matrix

User                    SSH Access      Sudo            Application Files       Configuration       Logs            Application Data
admin       	        SSH key         Full            Full control            RW-                 Full control    Full control
deploy                  SSH key         Limited 	    R-X                     R-X                 R--             R--
appsvc                  no              no              R-X                     R--                 RW-             RW-

R - read;
W - write;
X - execute;
'-' - none.

## 2. Access Control Principles

**Administrator (`admin`):** Full administrative access to the system and application resources.

**Deployment user (`deploy`):** Limited administrative privileges and read-only access to application configuration, logs, and data where required. Application files are read-only by default; write access is granted only when needed for deployment and through a controlled mechanism.

**Application service account (`appsvc`):** No SSH or sudo access. The account has read and execute permissions for application files, read-only access to application configuration, and read and write permissions for application logs and data as required by the application.

The matrix describes the intended access model. Effective permissions must be verified against the actual account configuration, group memberships, filesystem permissions, ACLs, sudoers rules, and SSH configuration.