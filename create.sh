#!/bin/bash
BASEUID=100000
BASEGID=100000
LXC_PATH="/net/lxc/user"
LXC_BASE="/net/lxc"
LXC_USER="lxc"
LXC_TEMPLATE="/net/lxc/lxc-archlinux-userns"
if [[ $1 == "" ]]; then
    echo "No Username"
    exit
fi
id $1 > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "User didn't exist!"
    exit 1
fi
lxc-create -P $LXC_PATH -t $LXC_TEMPLATE -n "$1"
if [[ $? -ne 0 ]]; then
    exit 1
fi
echo "Finish Creating lxc"
notuid0=$(find $LXC_PATH/"$1"/rootfs -not -uid 0)
notgid0=$(find $LXC_PATH/"$1"/rootfs -not -gid 0)
facl=$(getfacl -R -s -p $LXC_PATH/"$1"/rootfs | grep "# file:" | awk '{print$3}')
if [[ "$notuid0" != "" ]]; then
    echo "Files not own by root"
    notuid0=$(echo "$notuid0" | awk '{printf "\"%s\" ",$1; system("stat -c \"%u\" "$1);}')
    echo "$notuid0"
fi
if [[ "$notgid0" != "" ]]; then
    echo "Files not grouped by root"
    notgid0=$(echo "$notgid0" | awk '{printf "\"%s\" ",$1; system("stat -c \"%g\" "$1);}')
    echo "$notgid0"
fi
chown -R $BASEUID:$BASEGID $LXC_PATH/"$1"/rootfs
if [[ "$notuid0" != "" ]]; then
    echo "$notuid0" | awk -v BASEUID=$BASEUID '{system("chown "$2+BASEUID" "$1);}'
fi
if [[ "$notgid0" != "" ]]; then
    echo "$notgid0" | awk -v BASEGID=$BASEGID '{system("chgrp "$2+BASEGID" "$1);}'
fi
if [[ "$facl" != "" ]]; then
    echo "Files using facl"
    echo "$facl" | while read filename;
    do
        echo "$filename"
        echo "==BEFORE=="
        getfacl -n $filename
        tmp=$(getfacl -p -n $filename)
        tmp=$(echo "$tmp" | grep '^[^#]' |
            awk -F: -vBASEUID=$BASEUID -vBASEGID=$BASEGID '{
                OFS=":";
                if($1!="default"&&$1=="user"&&$2!="")
                    {$2=$2+BASEUID}
                else if($1!="default"&&$1=="group"&&$2!="")
                    {$2=$2+BASEGID}
                else if($1=="default"&&$2=="user"&&$3!="")
                    {$3=$3+BASEUID}
                else if($1=="default"&&$2=="group"&&$3!="")
                    {$3=$3+BASEGID}
                print$0;
            }')
        setfacl -b $filename
        echo "$tmp" | setfacl -M - $filename
        echo "==AFTER=="
        getfacl -n $filename
    done
fi

chown $BASEUID:$LXC_USER $LXC_PATH/$1
chown $LCX_USER:$LXC_USER $LXC_PATH/$1/config
sed -i 's/lxc.net.0.type = empty//g' $LXC_PATH/$1/config 
echo "lxc.include = /usr/share/lxc/config/userns.conf" >> $LXC_PATH/$1/config
echo "lxc.include = $LXC_BASE/pulxc.conf" >> $LXC_PATH/$1/config
echo "lxc.idmap = u 0 $BASEUID 65536" >> $LXC_PATH/$1/config
echo "lxc.idmap = g 0 $BASEGID 65536" >> $LXC_PATH/$1/config
nextip=$(cat $LXC_BASE/NEXTIP)
echo "lxc.net.0.type = veth" >> $LXC_PATH/$1/config
echo "lxc.net.0.link = lxcbr0" >> $LXC_PATH/$1/config
echo "lxc.net.0.ipv4.address = 192.168.100.$nextip/24" >> $LXC_PATH/$1/config
echo "lxc.net.0.ipv4.gateway = 192.168.100.1" >> $LXC_PATH/$1/config
echo "lxc.net.0.name = eth0" >> $LXC_PATH/$1/config
echo "lxc.net.0.flags = up" >> $LXC_PATH/$1/config
echo "Using ip 192.168.100.$nextip"
nextip=$(($nextip+1))
echo $nextip > $LXC_BASE/NEXTIP
