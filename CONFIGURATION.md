PULXC Configuration
===

## file structure
```
/var/lib/pulxc/: storage of the users' lxc
/etc/pulxc/: config for pulxc
/usr/lib/pulxc/: the shell scripts, helpers
/usr/bin/: pulxc-attach, pulxc-create, pulxc-destroy
/usr/lib/systemd/system/: unit files
```
In `/var/lib/pulxc` there are `lxc/` `log/`

All pulxc will be stored inside `lxc/` as the way `--lxcpath=/var/lib/pulxc/lxc` in the argument calling lxc

If you start the `pulxc-dblg@username` service the log will be saved at `log/username.log`


## config

### pulxc.conf

`/etc/pulxc/pulxc` is the main config file

The format is `KEY=VALUE` the `VALUE` should only consist alphanumeric and `_-/`

Key | Description
--- | ---
BASE_PATH| the place where users' lxc should save at
BASE_SUBUID| subuid start of pulxc
BASE_SUBGID| subgid start of pulxc
CGROUP_CPUSET_CPUS| the cgroup cpuset.cpus settings for all pulxc (in total)
CGROUP_CPUSET_MEMS| the cgroup cpuset.mems settings for all pulxc (in total)
BRIDGE_INTERFACE| the bridge the pulxc will connect to
IP_PREFIX| the first 3 part of the ipv4 address of pulxc
GATEWAY| the gateway address

because it is hard coded to run as /24 subnet

you can modify the pulxc-create if you want other subnet size

### pulxc-lxc.conf

This file will be included by lxc itself, you can set configs to every pulxc, for example , cap drops.