---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: Git Server Over SSH\
Date: 2019-02-09\
Tags: \
Blog: [https://mike.carif.io/blog/git-server-over-ssh.html](https://mike.carif.io/blog/git-server-over-ssh.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/src/git-server-over-ssh.md](https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/src/git-server-over-ssh.md)
---

# Git Server Over SSH

## Introduction

There are a number of recipes for creating [remote git repositories using `scp` or `ssh`](https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server) as the transport protocol. 
I didn't find them very clear or methodical and, in fact, it's pretty easy to get hung up on ssh details before you even
get the git stuff working. So I'm going to replicate the exercise with a little more tutorial explaination and with examples. 
This post was motivated from an attempt to use a remote server (at Digital Ocean) as a git repo. I got there eventually, 
but stumbled a few times along the way. You can learn from my scrapes.

Although there are several approaches to serving a git repository remotely, ssh is (claimed anyways) the easiest for a small number of users, say less than 10. 
You need to know a little bit about creating ssh keys, scp and a bit about [ssh config]() and even DNS (to create memorable DNS hostname). 
There are moving parts, but with a little bit of discipline and some testing along the way, you should be able to do what you need. In particular, you will already
have ssh installed on your remote (Linux) machine, so you don't need to install software.

Before we leave the shore below, a few orienting comments. This post makes a few assumptions, namely:

* You're using a current (as of 02/2019) Linux, say Ubuntu `cosmic` or Fedora 29 on both your local and remote hosts.

* You have `root` access on the remote host.

* You can edit files with the editor of your choice. (Choose emacs, the One True Editor.)

* You can install software using your system's package manager as needed (Debian/Ubuntu: `apt-get`, Fedora: `dnf`).

* You can find the right configuration files on your platform, for example (say) `/etc/ssh/sshd_config`. Linux distro move these things around for their own
  internal consistency -- good for them -- but that means you sometimes need to search. `find`, `grep`, and `locate` are your friends. As is `man`.
  
* You are using the bash shell or can translate `bash` to your shell on the fly. The command aren't hard, but I also did no testing for other shells, e.g. `zsh`, `fish` or `csh`.

* I've turned off the remote host's firewall to simplify configuration. You probably have the `ssh` default port 22 already open if you run a firewall. But if things go hinky,
  you may have to turn the firewall off, debug the problem(s), turn it back on and debug the firewall problem(s). Yes, this can be time consuming, but so is flailing.
  
* I've turned off `selinux` for the machine(s) that have them installed. As with the firewall above, you may have to turn `selinux` off (or set it be "permissive"), debug, turn it back to "enforcing" and
  debug again. Yes, this can be time consuming, but so is flailing.

Having read more than a few longer tutorials like this one, I'm often torn between the impatience of getting something done and moving on to "more important things" and taking a moment (or an hour or even an afternoon)
to understand what's actualy going on. Having spent a few days myself on this -- doing the initial exercise of setting up a remote git repo, screwing it up, realizing there isn't anything tutorial and current on this topic, writing it
-- I think it's worthy of your attention, but let me sell you -- briefly! -- now. In the age of the cloud (i.e. now), you will need to ssh into remote machines all the time, either directly (using the `ssh` command or all it's many variants e.g. `pagent` on windows) or indirectly using some wrapper e.g. `git`. If, like me, you learned enough in the past to "get by" with lotsa "cut-and-paste", you'll need to up your game a little bit and [level up](https://en.m.wiktionary.org/wiki/level_up) as my son likes to say. Of course there are books devoted to this topic. No, I haven't read them either.

## Notation

Some notes on notation. This post follows the usual pattern of "explain the next step", do the step (cut-and-paste the bash commands) and then "test the results". If you did the step but don't get the results you want, you will need
to figure out why. Unfortunately, that might include that my tutorial is flawed. But that's the point of testing each step. You are building up the final answer. The commands are designed to be "cut-and-paste" but you still need to think as you do them. I would have loved to have written (say) a python script that "just creates a remote git repo over ssh". Maybe someday I will ... or someone more capable will. But for now, it's manual. You'll learn something!

Let's start.

First, create a few local bash variables to make the "cut-and-paste" easier.

```bash
$ p=''  # yes, this is confusing, I'll describe it below; note that it's the prompt however for all subsequent commands
$p export local_user=$USER  # or the whatever name you want for the local user
$p export local_host=$HOST
$p export remote_user=$USER
$p export remote_host=atlantis.local # a test machine on my local lan
$p echo ${local_host}
$p echo ${local_user}
$p echo ${remote_host}
$p echo ${remote_user}
```

So, what's with `p`? It's a hack. It lets me indicate user input in the text without you constantly editing commands as you paste them into a bash shell. If you were to paste the bash commands above after the first, it would look like:

```bash
$ $p export local_user=$USER  # or the whatever name you want for the local user
$ $p export local_host=$HOST
$ $p export remote_user=$USER
$ $p export remote_host=atlantis.local # a test machine on my local lan
$ $p echo ${local_host}
$ $p echo ${local_user}
mcarifio
$ $p echo ${remote_host}
atlantis.local
$ $p echo ${remote_user}
mcarifio
```

Since `$p` expands to the empty string, it's effectively a "no-op".

## Preparation

Let's do a quick smoketest. Can you run the `ssh` command? One you do, what have you run?

```bash
$p ssh -V  # reports a newish version?
OpenSSH_7.7p1 Ubuntu-4ubuntu0.2, OpenSSL 1.0.2n  7 Dec 2017

$p type ssh # run system ssh?
ssh is hashed (/usr/bin/ssh)

$p readlink -f /usr/bin/ssh  # not a link to somewhere else?
/usr/bin/ssh

$p file /usr/bin/ssh  # running an executable?
/usr/bin/ssh: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=63696819f538324faa1a7982133fcbb5e3ccc9ba, stripped

$p lsb_release -a  # What's your distro? Affects the next command...
LSB Version:	core-9.20170808ubuntu1-noarch:printing-9.20170808ubuntu1-noarch:security-9.20170808ubuntu1-noarch
Distributor ID:	Ubuntu
Description:	Ubuntu 18.10
Release:	18.10
Codename:	cosmic

$p dpkg -S /usr/bin/ssh  # Ubuntu cosmic, ssh installed from a system package?
openssh-client: /usr/bin/ssh

$ dnf repoquery --installed -f /usr/bin/ssh  # fc29, ssh installed from a system package?
openssh-clients-0:7.9p1-3.fc29.x86_64
```

Hopefully, you'll find no shenigans with command aliases, bash functions or scripts/executables shadowing the official `ssh` that came from a platform package. Likewise, you're not getting shuttled off to another executable.
I'm demonstrating a healthy paranoia here, but stranger things have happened. The Interwebs also advocates all sorts of "fixes" for `ssh` which involve intercepting `/usr/bin/ssh` in some way. Very creative. You probably want to avoid them if possible.

Can you connect to `${remote_host}`?

```bash
$p ssh ${remote_host} touch .hushlogin  # stop login messages
$p ssh  ${remote_host} /bin/true  # no error?
$p ssh ${remote_host} id  # is this ${remote_user}?
uid=1000(mcarifio) gid=1000(mcarifio) groups=1000(mcarifio),10(wheel),970(wireshark)
```

The `uid` command will return something different for you, but hopefully `${remote_user}` is the uid.

Alternatively, you can ssh as root. (This requires some configuration at ${remote_host}):

```bash
$p ssh root@${remote_host} touch .hushlogin
$p ssh root@${remote_host} id
uid=0(root) gid=0(root) groups=0(root)
```




## Debugging SSH

What do you do if you don't get this kind of output or you can't even connect? After all, there are several unstated assumptions in the commands above, which we're not about to ummm state.
Generally, `ssh` will fail because you think you're doing one thing and you're doing another. For example, you're using the wrong username, or key file or remote host or port. Configuring ssh requires
some understanding of `ssh` and the ssh configuration files `~/ssh/config` and `/etc/ssh/ssh_config`. For example, unlike most applications, the _first_ configuration directive applied wins 
(see https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client). This means directives best appear from the most specific host to least. Moreover `~/.ssh/config`
is loaded _before_ `/etc/ssh/ssh_config`. Therefore, it's useful to ask `ssh` what it thinks the options are for a remote host:

```bash
$p ssh -G ${remote_host}  # -G dumps all ssh options _after_ matching the hostname and applying directives.
user mcarifio
hostname atlantis.local
port 22
...
tunneldevice any:any
controlpersist no
escapechar ~
ipqos lowdelay throughput
rekeylimit 0 0
streamlocalbindmask 0177

$p ssh -G ${remote_host} | grep -E '(user|identityfile) '  # grep just what you need; note the options are all lower case
user mcarifio
identityfile ~/.ssh/id_rsa
identityfile ~/.ssh/id_dsa
identityfile ~/.ssh/id_ecdsa
identityfile ~/.ssh/id_ed25519
identityfile ~/.ssh/id_xmss
```

You have to understand what the configuration directives and values mean, which isn't always obvious. Experimenting can augment reading.

You can ask `ssh` to trace what it's trying to do during a connection with `-v`. The more `v`'s you add the more verbose the output:

```bash
$p ssh -vvv ${remote_host}
OpenSSH_7.7p1 Ubuntu-4ubuntu0.2, OpenSSL 1.0.2n  7 Dec 2017
debug1: Reading configuration data /home/mcarifio/.ssh/config
debug3: /home/mcarifio/.ssh/config line 8: Including file /home/mcarifio/.ssh/config.d/sshit/ssh-hosts.conf depth 0
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/sshit/ssh-hosts.conf
debug3: /home/mcarifio/.ssh/config.d/sshit/ssh-hosts.conf line 1: Including file /home/mcarifio/.ssh/config.d/sshit/hosts.d/git.carif.io.host.conf depth 1
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/sshit/hosts.d/git.carif.io.host.conf
debug3: /home/mcarifio/.ssh/config.d/sshit/ssh-hosts.conf line 1: Including file /home/mcarifio/.ssh/config.d/sshit/hosts.d/mcarifi0\\@github.com.host.conf depth 1
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/sshit/hosts.d/mcarifi0\\@github.com.host.conf
debug3: /home/mcarifio/.ssh/config.d/sshit/ssh-hosts.conf line 1: Including file /home/mcarifio/.ssh/config.d/sshit/hosts.d/mike.carif.io.host.conf depth 1
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/sshit/hosts.d/mike.carif.io.host.conf
debug3: /home/mcarifio/.ssh/config line 9: Including file /home/mcarifio/.ssh/config.d/sshit/ssh-defaults.conf depth 0
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/sshit/ssh-defaults.conf
debug1: /home/mcarifio/.ssh/config.d/sshit/ssh-defaults.conf line 12: Applying options for *.local
debug1: /home/mcarifio/.ssh/config.d/sshit/ssh-defaults.conf line 17: Applying options for *
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: Applying options for *
...
```

If you want to experiment with a modified configuration file _or_ you've divided your `config` into parts, you can load the exact file you want with `ssh -F /path/to/config ${remote_host}`. Note that it's *capitalized*; `-f` is a bonafilde switch having nothing to do with configuration files.



## Interlude 0

So far:

* You have an installed `ssh` client.

* You can ssh into `${remote_host}` perhaps as `${remote_user}`. You might be prompted for a password.

## Passwordless SSH

Preferably, you can do the operations above using ssh keys and not a password. If you can't, then do the following:

```bash
$p keys=${HOME}/.ssh/keys.d  # put new keys in a dedicated folder
$p mkdir -vp ${keys}  # create the key folder
mkdir: created directory '/home/remote_user/.ssh/keys.d'

$p pathname=${keys}/${remote_user}@${remote_host}_rsa
$ ssh-keygen -N '' -t rsa -b 4096 -o -C "${HOST}:${pathname} for user ${USER}" -f ${pathname}  # no password for key, simplifies later usage
Your identification has been saved in ${keys}/${remote_user}@${remote_host}_rsa.
Your public key has been saved in ${keys}/${remote_user}@${remote_host}_rsa.pub.
The key fingerprint is:
SHA256:zNqg33hou6DkMx+Ka06ah85YTq3+mPP0A7IJ6d2ccoc ${HOST}:${keys}/${remote_user}@${remote_host}_rsa for user ${USER}
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|                 |
|       o         |
| .    . S        |
|o .... +         |
|.+=+O.+..        |
|*@BX E++.        |
|XBXB*.B=.        |
+----[SHA256]-----+
$ cat ${pathname}.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3AVUpCzaJjJSSXplK5tVSXisRFxZ7jfKvksAL+H7z/gOR0OpXaxc2LtcnsbqhuwfYgl1Wz2+D+LxXFHlv9+Ag+2wf8kdkKuBaGXgAPWybPU7EOPMqE9SB8VrMfNR7/9PCpC0MlsEa07Gta0GswW2I6WUZg7lrx75/cz5LrP5uvlVKIS4Zhm9sDCPnkWlyhgFJlmjxJOr8qJB6QbpbMtIogkn5t4TVcE+X4jiV+KYe3AmwvL1XgLrMUTF1zG6N/zBhni7FT2m6Cra7GPcxswWDkrTx4r88gmynaoyAz/0OpqoWHxEx14V97eegP8z59DYjla0pC5XTk5DGe0aCkpecxD81BYLzvmnnrbUcf61igQ6gbRMNmNlwd0Xqsow6KUTPpkulWAi67Svh9quKz4oXR01ftj6yePoycRaFBhqF3FOteiYWK+wsKef2tUOFf3Cme9op/xY3XnUixopJolRV0CM5DwbxN2F8MkyYdFcF9o3NVvfdv2FT+A4oQLR89TB1yhoHiDA2/MD5aCkW+NDU7qsdOKQWK0X+kVdEuaiXougfpJdsc/bV3wUTVfPKaGu5JrNo+xvaOLV8290eyevxsQfFDr9kgk0rX3ro35GD42Lhj1aGiocWDZ19M2nDToZkdOBT7sX4KjGB1og4FbODQoxxGE3a6reZC+OmJV4lOw== ${HOST}:${pathname} for user ${USER}

$ ssh-copy-id -i ${pathname} ${remote_user}@${remote_host}  # password prompt?
$ ssh -v -i ${pathname} ${remote_user}@${remote_host}  # no password
$ cat < EOF >> ~/.ssh/config
Host ${remote_host}
  IdentitiesOnly=yes
  IdentityFile=${pathname}
  User=${remote_user}
EOF
$ ssh ${remote_host} id
```

At this point, you can ssh into `${remote_host}` as user `${remote_user}`. Do so:

```bash
$p ssh ${remote_host}
$p sudo -i
# adduser -G sudo git
# usermod -G git ${SUDO_USER}
# install -v -o git -g git --mode 0700 -d ~git/.ssh
# install -v -o git -g git --mode 0600 ~${SUDO_USER}/.ssh/authorized_keys ~git/.ssh # copy all ${SUDO_USER}'s authorized keys to git
# install -v -o git -g git ~${SUDO_USER}/.hushlogin ~git/
# install -v -o git -g git -d ~git/repos
```

(The [`install`](https://www.gnu.org/software/coreutils/manual/html_node/install-invocation.html#install-invocation) command doesn't get enough love. It's `cp` on steroids without the complexity of `rsync`.)

## Create User `git`'s Keyfile and add it to `${remote_host}:~git/.ssh/authorized_keys`

In a separate terminal window on `${local_host}` as user `${local_user}` try sshing to `git@${remote_host}`:

```bash
$ ssh -v git@${remote_host} id 
uid=1001(git) gid=1001(git) groups=1000(sudo) ...
```

At this point, you have (at least) three users at `${remote_host}`: `${remote_user}`, `root` and `git`. Using the technique above, create an rsa key pair for `git` and copy it to `${remote_host}` for user `git`:

```bash
$p pathname=${keys}/git@${remote_host}_rsa
$p ssh-keygen -N '' -t rsa -b 4096 -o -C "${HOSTNAME}:${pathname} for user git" -f ${pathname}  # no password for key, simplifies later usage
Your identification has been saved in ${pathname}
Your public key has been saved in ${pathname}.pub
The key fingerprint is:
SHA256:zNqg33hou6DkMx+Ka06ah85YTq3+mPP0A7IJ6d2ccoc ${HOST}:${pathname} for user git
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|                 |
|       o         |
| .    . S        |
|o .... +         |
|.+=+O.+..        |
|*@BX E++.        |
|XBXB*.B=.        |
+----[SHA256]-----+
$ cat ${pathname}.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3AVUpCzaJjJSSXplK5tVSXisRFxZ7jfKvksAL+H7z/gOR0OpXaxc2LtcnsbqhuwfYgl1Wz2+D+LxXFHlv9+Ag+2wf8kdkKuBaGXgAPWybPU7EOPMqE9SB8VrMfNR7/9PCpC0MlsEa07Gta0GswW2I6WUZg7lrx75/cz5LrP5uvlVKIS4Zhm9sDCPnkWlyhgFJlmjxJOr8qJB6QbpbMtIogkn5t4TVcE+X4jiV+KYe3AmwvL1XgLrMUTF1zG6N/zBhni7FT2m6Cra7GPcxswWDkrTx4r88gmynaoyAz/0OpqoWHxEx14V97eegP8z59DYjla0pC5XTk5DGe0aCkpecxD81BYLzvmnnrbUcf61igQ6gbRMNmNlwd0Xqsow6KUTPpkulWAi67Svh9quKz4oXR01ftj6yePoycRaFBhqF3FOteiYWK+wsKef2tUOFf3Cme9op/xY3XnUixopJolRV0CM5DwbxN2F8MkyYdFcF9o3NVvfdv2FT+A4oQLR89TB1yhoHiDA2/MD5aCkW+NDU7qsdOKQWK0X+kVdEuaiXougfpJdsc/bV3wUTVfPKaGu5JrNo+xvaOLV8290eyevxsQfFDr9kgk0rX3ro35GD42Lhj1aGiocWDZ19M2nDToZkdOBT7sX4KjGB1og4FbODQoxxGE3a6reZC+OmJV4lOw== ${HOST}:${pathname} for user git
$p scp ${pathname}.pub ${remote_host}:/tmp
$p cat < EOF >> ~/.ssh/config
Host git git.${remote_host}
  RequestTTY=no
  HostName ${remote_host}
  IdentitiesOnly=yes
  IdentityFile=${pathname}
  User=git
EOF
```

Then back up on `${remote_host}` as user `${remote_user}`:

```bash
sudo -u git cat /tmp/git@${remote_host}.pub >> ~git/.ssh/authorized_keys
```

Finally, _back_ on `${local_host}` as user `${local_user}`:

```bash
$p ssh git@${remote_host} git init --bare repos/smoketest.git
$p mkdir -p ~/client/smoketest && cd $_
$p git init .
$p echo ${USER} $(date) > committers.txt
$p git add committers.txt
$p git commit -m 'start'
$p git remote add git@${remote_host}:repos/smoketest.git
$p git push -u origin master
$p git clone git@${remote_host}:repos/smoketest.git /tmp/repos/smoketest
$ diff committers.txt /tmp/repos/smoketest/comitters.txt
no differences
```

## Debugging GIT

What do you do if you don't get this kind of out or you can't even connect (sounds familiar)? You can ask git to show you what it's doing:

```bash
$p GIT_SSH_COMMAND="ssh -vvv" GIT_TRACE=1 git clone git@${remote_host}:repos/smoketest.git
... much output ...
```

You can omit either `GIT_SSH_COMMAND` or `GIT_TRACE`. You can also use `-v`. Again, as with `ssh` above, interpreting these logs takes elbow grease and Google. But it can be done.


## Conclusion

If you made it this far and you now have an operational git repository over ssh, congratulations. If you fell off the tightrope, hopefully you didn't break anything on the landing. Using the debugging tips above, you have a shot
at deducing what went wrong. By configuring the access "bottom up" (ssh first, ssh for user `git` next and then finally cloning a repo using `git` over `ssh`), issues can be easier to diagnose.
Once you have one repo working for yourself, creating other repos and other users are pretty straightforward.

New repos for user `${local_user}`:

```bash
$p repo=new_repo
$p ssh git@${remote_host} git init --bare repos/${repo}.git
$p mkdir -p ~/client/${repo} && cd $_
$p git init .
$p echo -e "# README\ntbs" > README.md
$p git add README.md
$p git commit -m 'start'
$p git log -n1
$p git remote add git@${remote_host}:repos/${repo}.git
$p git push -u origin master
$p git clone git@${remote_host}:repos/${repo}.git /tmp/repos/${repo}
$p cat /tmp/repos/${repo}/README.md
```

Adding a new user `${user}` to access all repos on `${remote_host}` requires the new user to create a key pair for themselves:

```bash
$p pathname=~/.ssh/${user}@${remote_host}_rsa
$p ssh-keygen -N '' -t rsa -b 4096 -o -C "${HOSTNAME}:${pathname} for user ${user}" -f ${pathname}  # no password for key, simplifies later usage
Your identification has been saved in ${pathname}
Your public key has been saved in ${pathname}.pub
The key fingerprint is:
SHA256:zNqg33hou6DkMx+Ka06ah85YTq3+mPP0A7IJ6d2ccoc ${HOST}:${pathname} for user ${user}
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|                 |
|       o         |
| .    . S        |
|o .... +         |
|.+=+O.+..        |
|*@BX E++.        |
|XBXB*.B=.        |
+----[SHA256]-----+
$ cat ${pathname}.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3AVUpCzaJjJSSXplK5tVSXisRFxZ7jfKvksAL+H7z/gOR0OpXaxc2LtcnsbqhuwfYgl1Wz2+D+LxXFHlv9+Ag+2wf8kdkKuBaGXgAPWybPU7EOPMqE9SB8VrMfNR7/9PCpC0MlsEa07Gta0GswW2I6WUZg7lrx75/cz5LrP5uvlVKIS4Zhm9sDCPnkWlyhgFJlmjxJOr8qJB6QbpbMtIogkn5t4TVcE+X4jiV+KYe3AmwvL1XgLrMUTF1zG6N/zBhni7FT2m6Cra7GPcxswWDkrTx4r88gmynaoyAz/0OpqoWHxEx14V97eegP8z59DYjla0pC5XTk5DGe0aCkpecxD81BYLzvmnnrbUcf61igQ6gbRMNmNlwd0Xqsow6KUTPpkulWAi67Svh9quKz4oXR01ftj6yePoycRaFBhqF3FOteiYWK+wsKef2tUOFf3Cme9op/xY3XnUixopJolRV0CM5DwbxN2F8MkyYdFcF9o3NVvfdv2FT+A4oQLR89TB1yhoHiDA2/MD5aCkW+NDU7qsdOKQWK0X+kVdEuaiXougfpJdsc/bV3wUTVfPKaGu5JrNo+xvaOLV8290eyevxsQfFDr9kgk0rX3ro35GD42Lhj1aGiocWDZ19M2nDToZkdOBT7sX4KjGB1og4FbODQoxxGE3a6reZC+OmJV4lOw== ${HOST}:${pathname} for user ${user}

$ cat < EOF >> ~/.ssh/config
Host git ${remote_host}
  RequestTTY=no
  IdentitiesOnly=yes
  IdentityFile=${pathname}
  User=git
EOF
```

Ask the new user to email you `git@${remote_host}_rsa.pub`, which you will upload to user `git`'s `authorized_users`:

```bash
scp git@${remote_host}_rsa.pub git@${remote_host}:.ssh
ssh git@${remote_host} cat ~/.ssh/git@${remote_host}_rsa.pub >> ~/.ssh/authorized_keys
```

Then ask `${user}` to test:

```bash
$p git clone git@git.${remote_host}:repos/smoketest.git /tmp/repos/smoketest
```









