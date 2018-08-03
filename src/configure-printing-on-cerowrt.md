---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: How To Configure USB Printing on a CeroWrt Router\
Date: 2013-01-01\
Tags: bufferbloat, cerowrt, netgear, router, printer, ipp\
Blog: [https://mike.carif.io/blog/configure-printing-on-cerowrt.html]([https://mike.carif.io/blog/configure-printing-on-cerowrt.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/configure-printing-on-cerowrt.md](https://www.github.com/mcarifio/blog/blob/master/src/configure-printing-on-cerowrt.md)
---

# How To Configure USB Printing on a CeroWrt Router


_Note: This blog entry is actually from about five years ago and so is dated. The gist of the idea remains intact, namely that usb printers without wifi capabilities can use the router itself to provide wireless printing. Almost all newer printers have wifi built-in already, so this wifi-to-usb hack is less relevant. I hate throwing work away, however, so I've kept it for posterity. But whatever money you save using an older printer without wifi is consumed with the configuration exercise below. Buy a new printer (sadly).
Because that's probably the better approach, I've made no effort to clean up the approach below. I might someday if its warranted._

At my (ex)boss [Alex Chiang's](http://www.chizang.net/alex/blog/) recommendation, I purchased a [Netgear N600 Wireless Dual Band Gigabit Router](http://www.netgear.com/wndr3800) known in the biz as a _wndr3800_.
Alex suggested it to deal with the <a href="">[_bufferbloat problem_](http://www.bufferbloat.net/projects/bloat/wiki/Introduction) which basically
ruins streaming connections from the Internet. Like much of the world, I rely on the Internet and want to leverage the bandwidth I actually purchase. So I bought the
hardware and paved the device with new firmware: [CeroWrt](http://www.bufferbloat.net/projects/cerowrt/wiki/CeroWrt_flashing_instructions). CeroWrt is derived
from [OpenWrt](https://openwrt.org/), but adds modifications explicitly designed to address the bufferbloat problem. They have a website that 
describes the details, but its pretty dense reading.

The wndr3800 has a type A usb port, off of which you can hang a usb hub. With that, you can add external usb storage _and_ a usb adapted printer, in my case an 
[HP LaserJet 3330mfp](http://h10025.www1.hp.com/ewfrf/wc/product?cc=us&lc=en&dlc=en&product=66366), a physical monster I've run more than a decade, I think. 
This makes the printer available over both wired and wireless networking and turns the router into a print server also. But this is Linux and nothing
is easy. You need to install and configure [cups](http://www.cups.org/). Let the games begin! This didn't turn out to be easy. Or it was easy in retrospect. So
I decided to summarize how I did it, so that it might help you, Dear Reader, when your time comes.

Before I enumerate the steps, the better solution would be to figure out how to fix the cups package in cerowrt, 
including a better default configuration and perhaps even going upstream
to the cups project and crafting a better configuration language. Ha, ha, ha. Both are currently beyond me. It would be nice if every Linux variant didn't 
invent its own packaging utility. 
The complexity and confusion of Linux printing casts Microsoft's accomplishments here in a positive light. On Windows, you just plug the cable in, 
answer a few configuration questions
as needed and print.

Here we go.

All steps are done at the command line, as root, on the wndr3800, except for the first few.
You will need to ssh into the device. In the default configuration for cerowrt, the router's hostname is gw.home.lan. If you've changed it,
use that. If you're an IP person, the router's address is 172.30.42.1 by default.

```bash
client$ ping -c 1 gw.home.lan ## can you see the router?
PING gw.home.lan (172.30.42.1) 56(84) bytes of data.
64 bytes from cerowrt.local (172.30.42.1): icmp_req=1 ttl=64 time=0.309 ms

--- gw.home.lan ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.309/0.309/0.309/0.000 ms

client$ ssh-copy-id root@gw.home.lan # password-less ssh-ing
client$ ssh root@gw.home.lan # log in

```

You're in. Orient yourself.

```bash
root@studio5:~# cat /etc/openwrt_release ## confirm DISTRIB_TARGET
DISTRIB_ID="CeroWrt"
DISTRIB_RELEASE="3.10.17-3"
DISTRIB_REVISION="r38488"
DISTRIB_CODENAME="cambridge"
DISTRIB_TARGET="ar71xx/generic"
DISTRIB_DESCRIPTION="CeroWrt Cambridge 3.10.17-3"

root@studio5:~# cat /etc/opkg.conf ## you'll add to this later
src/gz cambridge http://snapon.lab.bufferbloat.net/~cero2/cerowrt/wndr/3.10.17-3/packages
dest root /
dest ram /tmp
lists_dir ext /var/opkg-lists
option overlay_root /overlay
```

First, let's install cups.

```bash
root@studio5:~# opkg list-installed | grep cups  ## not installed yet

root@studio5:~# opkg update ## get the latest packages
Downloading http://snapon.lab.bufferbloat.net/~cero2/cerowrt/wndr/3.10.17-3/packages/Packages.gz.
Updated list of available packages in /var/opkg-lists/cambridge.

root@studio5:~# opkg install kmod-usb-core kmod-usb-ohci libusb ## pre-reqs first
... output ...

root@studio5:~# opkg install cups ## package won't be found
```

Package cups not found. What gives? Checking the release notes for DISTRIB_RELEASE (3.10.17-3) indicates that cups didn't build (!) for this release. Great.
Since certwrt is derived from openwrt, they share the same packaging format. They could also share packages, especially ones that aren't dependent on the Linux kernel,
so called _user space_ programs. Cups runs in user space. So we're going to take a risk and add an openwrt repository to /etc/opkg.conf, install cups, then keep
going. This is a temporary workaround as of November 2013. Hopefully the cups build works and you don't have to do this.
          
          
```bash
root@studio5:~# cd /etc

root@studio5:~# (cat opkg.conf; echo 'src/gz openwrt http://downloads.openwrt.org/snapshots/trunk/ar71xx/packages/') > opkg-cups.conf # added openwrt repo

root@studio5:/etc# opkg -f opkg-cups.conf update ## update list of packages, include openwrt ones
Downloading http://snapon.lab.bufferbloat.net/~cero2/cerowrt/wndr/3.10.17-3/packages/Packages.gz.
Updated list of available packages in /var/opkg-lists/cambridge.
Downloading http://downloads.openwrt.org/snapshots/trunk/ar71xx/packages//Packages.gz.
Updated list of available packages in /var/opkg-lists/openwrt.

root@studio5:/etc# opkg install cups ## magic
root@studio5:/etc# opkg update ## forget openwrt repo

root@studio5:/etc# opkg list-installed|grep cups ## installed?
cups - 1.5.4-1
libcups - 1.5.4-1
libcupscgi - 1.5.4-1
libcupsmime - 1.5.4-1
libcupsppdc - 1.5.4-1

```

You've got the bits on the wndr3800. Now the fun begins. First let's install a VCS so that we can recover from configuration mistakes. 
Git will do. This step is optional. If you don't like git, don't use it.Then we'll modify /etc/cups/cupsd.conf and a few other things, 
so cupsd works. My notes here are sketchy. _Caviat emptor._

```bash
root@studio5:/etc/cups# opkg install git
Installing git (1.8.4-1) to root...
Downloading http://snapon.lab.bufferbloat.net/~cero2/cerowrt/wndr/3.10.17-3/packages/git_1.8.4-1_ar71xx.ipk.
Configuring git.

root@studio5:/etc/cups# git config --global user.email "your@email" ## use *your* email
root@studio5:/etc/cups# git config --global user.name "Your Name"   ## use *your* name
root@studio5:/etc/cups# git init .
Initialized empty Git repository in /etc/cups/.git/

root@studio5:/etc/cups# git add .
root@studio5:/etc/cups# git commit -m 'distribution configuration'
```

The git part is revisionist history. I didn't actually do it the first time around. Before editing /etc/cups/cupsd.conf, let's configure some things
as directed by [Matte47](http://mattie47.com/getting-cups-working-on-openwrt/).

```bash
root@studio5:/etc/cups# chmod 700 /usr/lib/cups/backend/usb ## workaround for a bug in cups
root@studio5:/etc/cups# ls -la /usr/lib/cups/backend/usb
-rwx------    1 root     root         59828 Nov  2 23:45 /usr/lib/cups/backend/usb

root@studio5:/etc/cups# /usr/lib/cups/backend/usb ## can cups see your printer? 
DEBUG: list_devices
DEBUG: libusb_get_device_list=3
DEBUG2: Printer found with device ID: MFG:Hewlett-Packard;CMD:PJL,MLC,PCL,POSTSCRIPT,PCLXL;MDL:HP LaserJet 3330;CLS:PRINTER;DES:Hewlett-Packard LaserJet 3330;MEM:22MB Device URI: usb://HP/LaserJet%203330?serial=00SGK26C0WZM
direct usb://HP/LaserJet%203330?serial=00SGK26C0WZM "HP LaserJet 3330" "HP LaserJet 3330" "MFG:Hewlett-Packard;CMD:PJL,MLC,PCL,POSTSCRIPT,PCLXL;MDL:HP LaserJet 3330;CLS:PRINTER;DES:Hewlett-Packard LaserJet 3330;MEM:22MB" ""
```

Note that you may have to fiddle with your printer to get the router to sense it. I had to unplug the cable, 
reboot the router and then plug the cable back in. This is magic here. 
Next modify /etc/cupsd.conf according to this diff file. You'll have to do it by hand. Patch appears missing. (Thanks, Alex, for educating me about diff and patch.)

```bash
--- cupsd.dist.conf
+++ cupsd.conf
@@ -9,6 +9,9 @@
#                                                                      #
########################################################################

+# mgc: diff cups.dist.conf cups.conf ## see what changed
+# http://www.papercut.com/kb/Main/CupsHostError
+ServerAlias * 

AccessLog syslog
ErrorLog syslog
@@ -23,8 +26,8 @@
#PrintcapFormat BSD
RequestRoot /var/cups
#RemoteRoot remroot
-User nobody
-Group nogroup
+User root ## for /usr/lib/cups/backend/usb 
+Group root
RIPCache 512k
TempDir /var/cups
Port 631
@@ -34,14 +37,14 @@
BrowseProtocols cups

<Location />
-Order Deny,Allow
-Allow From 127.0.0.1
-Allow From 192.168.1.0/24
+ Order Deny,Allow
+ Allow From 127.0.0.1
+ # http://www.bufferbloat.net/projects/cerowrt/wiki/Default_network_numbering
+ Allow From 172.30.42.0/27
+ AuthClass Anonymous
</Location>

<Location /admin>
-AuthType Basic
-AuthClass System
-Order Allow,Deny
-Allow From All
+ Order Allow,Deny
+ Allow From 172.30.42.*
</Location>
```

The gist of these changes are: 1) deal with some cups bugs and 2) configure access to cerowrt's address range of 172.30.42.0/27.
We're getting closer. Let's enable and start the service.

```bash
root@studio5:/etc/cups# /etc/init.d/cupsd enable # service starts when router boots
root@studio5:/etc/cups# /etc/init.d/cupsd start
root@studio5:/etc/cups# logread # watch syslog, cups will talk to us
```

At this point we have a running cups. But cups doesn't know about the usb printer attached. We'll use the web ui to configure it _on the client computer_.

```bash
client$ gnome-open http://gw.home.lan:631/admin ## and then add a printer
```

When you configure the printer, you'll be asked for a printer driver. I chose _raw_ which basically says that the print client will format the document and then send
low level printer directives. I may have that wrong but I followed the Interweb's advice. It worked for me. 
Once you add the printer, you should be able to add a printer on your client using whatever configuration tool available. The printing protocol will be ipp and the url will
look something like ipp://gw.home.lan:631/printers/USB. On Windows, it will be something like http://gw.home.lan:631/printers/USB. Note that the Ubuntu client was able to 
discover the  printer but the Windows client couldn't (or I wasn't patient enough to let it keep trying). Find the closest print driver or hunt 
the exact right one down. I found something close on Windows and exact on Ubuntu. Print a test page. Cheer. Or boo, and then figure out what went 
wrong with syslog messages from the wnrd3800 and our Google overlord.
I was successfully able to print test pages and then print jobs from Ubuntu raring and Windows 7.
Once you have everything to your liking, commit your /etc/cups/cupsd.conf changes in git:

```bash
root@studio5:/etc/cups# git commit -m 'config changes work' cupsd.conf
[master (root-commit) 63b75b3] config changes work
1 file changed, 50 insertions(+)
create mode 100644 cupsd.conf
```

Good luck. Hope this helped. Printing is still too complicated on Linux. But there are many moving parts and not enough economic incentives to make it much easier.

