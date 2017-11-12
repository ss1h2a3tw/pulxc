# pulxc
A per user LXC for workstation environment

## Why using this
In workstation with LDAP, subuid/subgid is not available for current version of ldap (sssd/nss-pam-ldapd)
So a normal user can't start a unprivileged lxc by it self.

## Breif Implementation
A workaround is creating a local system user with subuid/subgid and let the user start the lxc.
And creating a setuid program to allow normal user to attach into their LXC
