# pulxc
A per user LXC for workstation environment

## Why using this
In workstation with LDAP, subuid/subgid is not available for current version of ldap (sssd/nss-pam-ldapd)

So a normal user can't start a unprivileged lxc by it self.

## Breif Implementation
A workaround is creating a local system user with subuid/subgid and let the user start the lxc.

And creating a setuid program to allow normal user to attach into their LXC

## Installation
create a user named pulxc, and assign subuid and subgid

setup the bridge network for lxc, including NAT, don't forget lxc-usernet

```
make
sudo make install
```

## Usage

`pulxc-create username` to create a lxc for the user

`pulxc-destroy username` to destroy the lxc, you need to stop it first

`systemctl start pulxc@username` to start it

`systemctl stop pulxc@username` to stop it

`systemctl enable pulxc@username` to make it start at boot

`systemctl start pulxc-dblg@username` to log the startup, the log file will be saved at /var/lib/pulxc/log/
