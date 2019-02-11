---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: Centos Hacking
Date: 2016-12-31\
Tags: nothing, good\
Blog: [https://mike.carif.io/blog/centos-hacking.html](https://mike.carif.io/blog/centos-hacking.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/centos-hacking.md](https://www.github.com/mcarifio/blog/blob/master/src/centos-hacking.md)
---

_This entry was written about 18 months ago. I recovered it from an old wordpress blog. There's an addendum at the bottom.


After several years away from the RedHat school of Linux using Debian and Ubuntu, I’m back. I have a work client that is using Centos 7 in the cloud, so I’m eating some of the dog food and running it locally on a (new) desktop machine, a Shuttle. I largely assembled the machine myself, but that’s not saying much. It’s not like the old days, where you plugged everything in part by part, cable by cable. I rather like the new days, frankly. Bought the Shuttle, appropriate memory (DMM4), a pair off largest SSD drives, an i7 cpu and some thermal paste. Took me less than an hour to put the parts together mostly because I was fretting to confirm that I purchased all the right stuff (did the Shuttle come with a cpu already? No. Did I buy the right memory? Yes. I did I buy the right cpu? Yes. Did I seat it properly? Yes. The notches make sure you can’t do it wrong. Are the sata cables connected? Yes. Are the disks screwed in? Yes.). Powered up first try. Saw all the devices and memory first try. Booted from the USB stick first try. Installed Centos correctly(ish) first try (I should have partitioned the disk myself and I should have used btrfs).

I’m pleased with the machine. A little pricey, but I bought the components and its easy to spend a little more on hardware when you spend nothing on software.

Centos is a server distribution, but I’m using it like a desktop. So this means I have to hunt a little bit for various desktopish applications like dia, blender or whatever. It’s worth the effort and forces me to brush the rust off my rpmology. I would do this again. I could probably do just as well with virtualbox or even docker|rkt. Nonetheless, its useful to force yourself to think the Centos way versus the Ubuntu way.

## Addendum 2018-08-12

Although the experiment above was useful, after several months I eventually jettisoned Centos and moved on to [Fedora Core](https://www.fedora.org/). There is value in seeing how another distro does things, in this case RedHat, which is the larger of the two major distribution companies. Fedora is also a good proving ground for some interesting Linux ideas such as flatpak (versus snap), wayland and systemd (although systemd is ubiquitious). I started with RedHat, switched to Ubuntu circa 2010, but now am back to tracking both and mining their good ideas. 
