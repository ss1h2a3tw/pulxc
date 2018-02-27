#!/bin/sh
source /etc/pulxc/pulxc.conf
/usr/bin/lxc-stop -P $BASE_PATH/lxc -n $1
