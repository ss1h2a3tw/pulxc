.PHONY: install

UID=500
GID=500
SUBUID=100000
SUBGID=100000

pulxc-attach:
	gcc -Wall -Wextra src/pulxc-attach.c -o pulxc-attach

install: pulxc-attach
	install -d -m 750 -o $(UID) -g $(SUBGID) $(DESTDIR)/var/lib/pulxc $(DESTDIR)/var/lib/pulxc/lxc $(DESTDIR)/var/lib/pulxc/log
	install -d -m 755 $(DESTDIR)/usr/bin $(DESTDIR)/usr/lib/systemd/system $(DESTDIR)/etc/pulxc $(DESTDIR)/usr/lib/pulxc
	install -Dm 644 systemd/pulxc-cgroup.service $(DESTDIR)/usr/lib/systemd/system
	install -Dm 644 systemd/pulxc@.service $(DESTDIR)/usr/lib/systemd/system
	install -Dm 644 systemd/pulxc-dblg@.service $(DESTDIR)/usr/lib/systemd/system
	install -Dm 755 script/setup-cgroup.sh $(DESTDIR)/usr/lib/pulxc
	install -Dm 755 script/startone.sh $(DESTDIR)/usr/lib/pulxc
	install -Dm 755 script/startone-dblg.sh $(DESTDIR)/usr/lib/pulxc
	install -Dm 755 script/stopone.sh $(DESTDIR)/usr/lib/pulxc
	install -Dm 755 script/pulxc-create $(DESTDIR)/usr/bin
	install -Dm 755 script/pulxc-destroy $(DESTDIR)/usr/bin
	install -s -Dm 4755 pulxc-attach $(DESTDIR)/usr/bin
	install -Dm 644 conf/pulxc.conf $(DESTDIR)/etc/pulxc
	install -Dm 644 conf/pulxc-lxc.conf $(DESTDIR)/etc/pulxc
	echo "1" > $(DESTDIR)/var/lib/pulxc/nextip
