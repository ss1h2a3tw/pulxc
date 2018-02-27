#!/bin/bash
for cgroup in /sys/fs/cgroup/*
do
    if [[ $cgroup == "/sys/fs/cgroup/systemd" ]] || [[ $cgroup == "/sys/fs/cgroup/unified" ]];
    then
        continue
    fi
    echo "adding subcontroller in $cgroup"
    rmdir $cgroup/lxc
    mkdir -p $cgroup/lxc
    chown -R lxc:lxc $cgroup/lxc
done

#Change these as your system hardware!
echo "0" > /sys/fs/cgroup/cpuset/lxc/cpuset.cpus
echo "0" > /sys/fs/cgroup/cpuset/lxc/cpuset.mems
echo "0" > /sys/fs/cgroup/cpuset/lxc/lxc/cpuset.cpus
echo "0" > /sys/fs/cgroup/cpuset/lxc/lxc/cpuset.mems
exit 0
