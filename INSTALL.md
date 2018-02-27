PULXC installation
===
## Installation

If you are using archlinux, you can install from pulxc-git in AUR

But you still need to configure sysctl and lxc-usernet

### Add conf to sysctl.d
`kernel.uprivileged_userns_clone=1`
### setup lxc-usernet
```
#/etc/lxc/lxc-usernet
pulxc veth pulxcbr0 99 255
```
### add user pulxc:pulxc
`useradd -b /var/lib -m -r pulxc`
### configure subuid subgid
```
touch /etc/subuid
touch /etc/subgid
usermod -v 100000-165535 -w 100000-165535 pulxc
```
### configure bridge

use the tool you want
```
#/etc/systemd/network/pulxcbr0.netdev
[NetDev]
Name=pulxcbr0
Kind=bridge
```
```
#/etc/systemd/network/pulxcbr0.network
[Match]
Name=pulxcbr0

[Network]
Address=192.168.100.254/24
```
configure ip forwarding and NAT if you need it.

### install the files
you can modify the uid/gid/subuid/subgid in Makefile to meet your pulxc's uid/gid/subuid/subgid
```
make
make install
```
