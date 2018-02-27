.PHONY: install

UID=500
GID=500
SUBUID=100000
SUBGID=100000

pulxc-attach:
	gcc -Wall -Wextra src/pulxc-attach.c -o pulxc-attach

install: pulxc-attach
	install -d -m 750 -o $(UID) -g $(SUBGID) /var/lib/pulxc /var/lib/pulxc/lxc /var/lib/pulxc/log
	install -d -m 755 /etc/pulxc
	install -d -m 755 /usr/lib/pulxc
	install -m 644 systemd/pulxc-cgroup.service /usr/lib/systemd/system
	install -m 644 systemd/pulxc@.service /usr/lib/systemd/system
	install -m 644 systemd/pulxc-dblg@.service /usr/lib/systemd/system
	install -m 755 script/setup-cgroup.sh /usr/lib/pulxc
	install -m 755 script/startone.sh /usr/lib/pulxc
	install -m 755 script/startone-dblg.sh /usr/lib/pulxc
	install -m 755 script/stopone.sh /usr/lib/pulxc
	install -m 755 script/pulxc-create /usr/bin
	install -m 755 script/pulxc-destroy /usr/bin
	install -m 4755 pulxc-attach /usr/bin
