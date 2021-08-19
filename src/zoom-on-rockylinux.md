---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Zoom, Wayland, Screensharing and RockyLinux \
Date: 2021-08-18 \
Tags: #zoom, #wayland, #rocky, #screensharing
Blog: [https://mike.carif.io/blog/zoom-on-rockylinux.html](https://mike.carif.io/blog/zoom-on-rockylinux.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/zoom-on-rockylinux.md](https://www.github.com/mcarifio/blog/blob/master/src/zoom-on-rockylinux.md)
---

# Zoom, Wayland, Screensharing and RockyLinux

I recently landed at [Ctrl IQ](https://www.ctrliq.com/). I've adopted [rockylinux](https://www.rockylinux.org/) as my primary linux distribution as a result after many year on ubuntu and fedora. Installing software and configuring my environment(s) takes a little time and a lotta learning curve, but that's the fun. Like many, I use zoom for video conferencing and -- more importantly -- screensharing. I've also made a concerted effort -- and shed some tears -- to adopt [wayland]() over X11. And I don't want to backslide, tempting as it can sometimes be. I recently tried to share my screen in a zoom meeting and was met with an error saying in so many words "rocky isn't supported for wayland". So I hacked it. Here's _my_ hack, which seems to work but which I hope will be unnecessary in short order.

I used a mash-up of [Rutenburg's](https://www.guyrutenberg.com/2020/06/22/fixing-zoom-screen-sharing-on-debian-unstable/) hack with a sprinkle of [os-release's](https://www.freedesktop.org/software/systemd/man/os-release.html) more arcane variables. As `root` here goes:

```bash
# mv /etc/os-release{,.dist} # save the distributed os-release
# cat > /etc/os-release << EOF
# NAME="Rocky Linux"
# VERSION="8.4 (Green Obsidian)"
# ID="rocky"
NAME="Centos"
VERSION="8.4"
ID="centos"
VARIANT="Rocky Linux"
VARIANT_ID="rocky"

ID_LIKE="rhel fedora"
VERSION_ID="8.4"
PLATFORM_ID="platform:el8"
PRETTY_NAME="Rocky Linux 8.4 (Green Obsidian)"
ANSI_COLOR="0;32"
CPE_NAME="cpe:/o:rocky:rocky:8.4:GA"
HOME_URL="https://rockylinux.org/"
BUG_REPORT_URL="https://bugs.rockylinux.org/"
ROCKY_SUPPORT_PRODUCT="Rocky Linux"
ROCKY_SUPPORT_PRODUCT_VERSION="8"
EOF
```

Here's how to read these changes:

* I have `os-release` claim that it's centos 8 since centos is supported and rocky can be thought of (currently) as a centos variant.

* I record that variation with `VARIANT*`. Variants _seem_ to overide their "base" counterparts. `lsb_release -a` reports the right stuff:

```bash
# lsb_release -a
LSB Version:	:core-4.1-amd64:core-4.1-noarch:cxx-4.1-amd64:cxx-4.1-noarch:desktop-4.1-amd64:desktop-4.1-noarch:languages-4.1-amd64:languages-4.1-noarch:printing-4.1-amd64:printing-4.1-noarch
Distributor ID:	Rocky
Description:	Rocky Linux release 8.4 (Green Obsidian)
Release:	8.4
Codename:	GreenObsidian
```

Once that's all in place zoom thinks it's running on a supported platform (which it is, frankly) and will happily share some or all the screen.


<!-- @publish: git commit -am "zoom-on-rockylinux" && git push -->
