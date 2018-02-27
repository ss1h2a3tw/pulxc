#!/bin/bash
source /etc/pulxc/pulxc.conf
for cgroup in /sys/fs/cgroup/*
do
    if [[ $cgroup == "/sys/fs/cgroup/systemd" ]] || [[ $cgroup == "/sys/fs/cgroup/unified" ]];
    then
        continue
    fi
    echo "adding subcontroller in $cgroup"
    rmdir $cgroup/pulxc
    mkdir -p $cgroup/pulxc
    chown -R pulxc:pulxc $cgroup/pulxc
done

#Change these as your system hardware!
echo "$CGROUP_CPUSET_CPUS" > /sys/fs/cgroup/cpuset/pulxc/cpuset.cpus
echo "$CGROUP_CPUSET_MEMS" > /sys/fs/cgroup/cpuset/pulxc/cpuset.mems
exit 0
