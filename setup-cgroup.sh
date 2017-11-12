#!/bin/bash
for cgroup in /sys/fs/cgroup/*
do
    rmdir $cgroup/lxc
    mkdir -p $cgroup/lxc
    chown -R lxc:lxc $cgroup/lxc
done

echo 1 > /sys/fs/cgroup/cpuset/cgroup.clone_children
echo "0-55" > /sys/fs/cgroup/cpuset/lxc/cpuset.cpus
echo "0-1" > /sys/fs/cgroup/cpuset/lxc/cpuset.mems
exit 0
