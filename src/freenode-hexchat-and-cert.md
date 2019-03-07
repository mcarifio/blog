---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: Freenode, Hexchat and cert, Oh My!\
Date: 2019-03-06\
Tags: #freenode,#hexchat, #cert, #auth
Blog: [https://mike.carif.io/blog/freenode-hexchat-cert.html](https://mike.carif.io/blog/freenode-hexchat-cert.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/freenode-hexchat-cert.md](https://www.github.com/mcarifio/blog/blob/master/src/freenode-hexchat-cert.md)
---

# Freenode, Hexchat and cert, Oh My!


For the next person, so that they don't flail.

```bash

$ type -p hexchat
/usr/bin/hexchat
$ hexchat --version
hexchat 2.14.2
$ mkdir  ~/.config/hexchat/certs
$ openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout ~/.config/hexchat/certs/client.pem -out ~/.config/hexchat/certs/client.pem # https://freenode.net/kb/answer/certfp
hexchat irc://chat.freenode.net:6667 # or run hexchat as you normally do
```                                                                                     

If you haven't logged in using a nick and password, do so:

```
/msg NickServ identify ${nick} ${password}  # example /msg NickServ identify carif y3ah!right
/msg add cert  # adds ~/.config/hexchat/certs/client.pem pub key, prints fingerprint
```

Reconfigure hexchat to use certs. Check that the fingerprints match:

```
openssl x509 -in ~.config/hexchat/certs/client.pem -outform der | sha1sum -b | cut -d' ' -f1'
```

If the fingerprints match, you can dispense with logging in and you'll have your nick available to access channels that require it.

That's great. Can't we make this stuff a little easier? Or the directions clearer?

