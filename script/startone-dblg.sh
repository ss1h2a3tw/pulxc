#!/bin/sh
#cgm create all lxc
cat /proc/self/cgroup
for cgroup in /sys/fs/cgroup/*
do
    echo $cgroup
    if [[ $cgroup == "/sys/fs/cgroup/systemd" ]];
    then
        continue
    fi
    echo $$ > $cgroup/lxc/tasks
done
cat /proc/self/cgroup
/usr/bin/lxc-start -p /net/lxc/userpid/$1.pid -P /net/lxc/user -n $1 --logfile=/tmp/lxc.log -l WARN
