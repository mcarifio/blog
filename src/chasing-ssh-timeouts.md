---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Chasing SSH Timeouts (and Other Tales of Woe) \
Date: 2019-02-2019 \
Tags: #ssh #timeout #autossh #mosh #ssh_config #debugging \
Blog: [https://mike.carif.io/blog/chasing-ssh-timeouts.html](https://mike.carif.io/blog/chasing-ssh-timeouts.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/chasing-ssh-timeouts.md](https://www.github.com/mcarifio/blog/blob/master/src/chasing-ssh-timeouts.md)
---

# Chasing SSH Timeouts (and Other Tales of Woe) 

I recently upgraded the nvidia driver on a Fedora Workstation 29 installation. It went horribly wrong and X wouldn't start correctly, a nice blank screen after the reboot. I spent several frustrating hours installing and uninstalling various versions of the `xorg-x11-drv-nvidia` package and installing the nvidia driver from source for example `NVIDIA-Linux-x86_64-410.93.run`. Nothing worked. All the more infuriating because it was an "unforced error". The existing driver was working just fine but when I did the fc29 upgrade -- having installed the driver "manually" (not using `dnf`) -- the upgrade didn't rebuild the nvidia kmods. Ugh. I got what I deserved.

That's a tale of woe. But not _this_ tale of woe. (I have enough tales of woe for `tail -f`.)

I finally gave up on X + nvidia + fedora on the machine. I may return to it, but not right now. Perhaps never. Depends on the result of my (upcoming) experiments. This machine isn't my "primary machine", it's just a way to experiment with and explore fedora. And compare it to the other "big" distro Ubuntu. Of course, [Redhat](https://www.redhat.com/about) dwarfs [Canonical](https://www.canonical.com/about) financially, nonetheless it's educational to compare the choices the two distros make. In some ways they seem to be converging on the desktop, but diverging in packaging: flatpak, snappy, dnf and apt.
But once I stopped running X on fedora, I was using the machine as a "compute server" and interacting with it either through the command line (ssh to bash or xonsh and perhaps tmux optionally), the FUSE file system `sshfs` on the primary machine and the tramp package in emacs 26 on the primary machine.


# To Write

ssh disconnects and what I did:

  * ssh client config
  * ssh server config
  * xauth and xauth with root
  * turning off firewalld
  * turning off selinux
  * the final answer

## mosh

## autossh


<!-- "deliberate practice" idea. Musicians purposefully playing music at different speeds to force them to think about playing. To escape rote -->


