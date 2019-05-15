---
Author: Mike Carifio &lt;<mike@carif.io>&gt;
Title: TIL `nvm install ${new_version} --reinstall-packages-from=${old_version}`\
Date: 2019-05-15\
Tags: nvm, npm, install\
Blog: [https://mike.carif.io/blog/TIL-npm-reinstall-packages-from.html](https://mike.carif.io/blog/TIL-npm-reinstall-packages-from.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/bin/../src/TIL-npm-reinstall-packages-from.md](https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/bin/../src/TIL-npm-reinstall-packages-from.md)
---

# TIL `nvm install ${new_version} --reinstall-packages-from=${old_version}`

I just installed the most recent version of node 12.2.0 onto my local workstation, upgrading from 11.10.0. Of course (and of course only in retrospect), all my global packages remained in 11.10.0. So I reissued the `nvm install` with the correct switch:

```bash
$ nvm install v12.2.0 --reinstall-packages-from=11.10.0
v12.2.0 is already installed.
Now using node v12.2.0 (npm v6.9.0)
Reinstalling global packages from v11.10.0...
/home/mcarifio/.nvm/versions/node/v12.2.0/bin/tsc -> /home/mcarifio/.nvm/versions/node/v12.2.0/lib/node_modules/typescript/bin/tsc
/home/mcarifio/.nvm/versions/node/v12.2.0/bin/tsserver -> /home/mcarifio/.nvm/versions/node/v12.2.0/lib/node_modules/typescript/bin/tsserver
... lotsa output, some error messages ...
added 4815 packages from 1454 contributors in 109.771s
Linking global packages from v11.10.0...
```

I found _linking_ here confusing. For example, I got an error reinstalling [yo]() with 12.2.0 and therefore installed the latest:

```bash
$ npm install -g yo@latest
... lotsa stuff ...

$ yo --version
2.0.6

$ type -p yo
/home/mcarifio/.nvm/versions/node/v12.2.0/bin/yo

$ nvm use 11.10.0
Now using node v11.10.0 (npm v6.9.0)
$ yo --version
2.0.5

$ nvm use default
Now using node v12.2.0 (npm v6.9.0)
$ yo --version
2.0.6
```

However both 11.10.0 and 12.2.0 seem to point to the exact same file(!):

```bash
$ ls -la $(type -p yo)
lrwxrwxrwx 1 mcarifio mcarifio 33 May 15 11:55 /home/mcarifio/.nvm/versions/node/v12.2.0/bin/yo -> ../lib/node_modules/yo/lib/cli.js
$ ls -la /home/mcarifio/.nvm/versions/node/v11.10.0/bin/yo
lrwxrwxrwx 1 mcarifio mcarifio 33 Apr  1 23:19 /home/mcarifio/.nvm/versions/node/v11.10.0/bin/yo -> ../lib/node_modules/yo/lib/cli.js

$ sha1sum $(readlink -e ~/.nvm/versions/node/v12.2.0/bin/yo )
6ca1769a355f274fdc4c18ac5a95450c1dbf218d  /home/mcarifio/.nvm/versions/node/v12.2.0/lib/node_modules/yo/lib/cli.js
$ sha1sum $(readlink -e ~/.nvm/versions/node/v11.10.0/bin/yo )
6ca1769a355f274fdc4c18ac5a95450c1dbf218d  /home/mcarifio/.nvm/versions/node/v11.10.0/lib/node_modules/yo/lib/cli.js
```

So the version indicates that they're different, but the command doesn't. Diffing the entire directory shows only differences in the `package.json` files. It's confusing,
but I'm going to assume that two different `yo` packages are installed.
