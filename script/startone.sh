#!/bin/sh
source /etc/pulxc/pulxc.conf
for cgroup in /sys/fs/cgroup/*
do
    echo $cgroup
    if [[ $cgroup == "/sys/fs/cgroup/systemd" ]] || [[ $cgroup == "/sys/fs/cgroup/unified" ]];
    then
        continue
    fi
    echo $$ > $cgroup/pulxc/tasks
done
cat /proc/self/cgroup
/usr/bin/lxc-start -P $BASE_PATH/lxc -n $1
