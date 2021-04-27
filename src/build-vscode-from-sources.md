---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Build vscode From Sources \
Date: 2021-04-27 \
Tags: #vscode \
Blog: [https://mike.carif.io/blog/build-vscode-from-sources.html](https://mike.carif.io/blog/build-vscode-from-sources.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/build-vscode-from-sources.md](https://www.github.com/mcarifio/blog/blob/master/src/build-vscode-from-sources.md)
---

# Build `vscode` From Sources

_tl;dr_: Building an application or tool from source can frustrate, especially if you vear from the directed path. I built vscode from source using volta, asdf and gyp from the Ubuntu repo.
I don't know if I was just lucky this time around. But it did work and it's a little more elegant than the github build directions.

Because I will eventually take a programming test at [CodeSignal](https://www.codesignal.com/), I wanted to experiment with [Visual Studio Code](https://code.visualstudio.com/) a little bit,
specifically it's [monaco](https://microsoft.github.io/monaco-editor/) editor. This isn't a perfect proxy -- I eventually just signed up for CodeSignal "as a developer" and experimented there.
But it was a useful exercise to build a version locally. And not overly painful. I'm still confused by some of vscode's innards. But as I explore more, perhaps I'll understand more.

According to the [build recipe](https://github.com/microsoft/vscode/wiki/How-to-Contribute#build), you need `node`, `yarn`, `python`, `gyp` and some packages. I went at it a little differently from the directions using [asdf](https://asdf-vm.com/) and [volta](https://volta.sh/), which I assume below you've installed already. Both have "one-liner" installation scripts:

```bash
$ volta install yarn # gets the right node for the latest yarn as well

$ yarn node --version 
yarn node v1.22.10
v15.7.0
Done in 0.02s.

$ which yarn
/home/mcarifio/.local/share/volta/bin/yarn

$ which -a node # too many nodes installed!
/opt/asdf/current/shims/node
/home/mcarifio/.local/share/volta/bin/node
/usr/bin/node
/bin/node




$ lsb_release -a
LSB Version:	core-11.1.0ubuntu2-noarch:printing-11.1.0ubuntu2-noarch:security-11.1.0ubuntu2-noarch
Distributor ID:	Ubuntu
Description:	Ubuntu 20.10
Release:	20.10
Codename:	groovy

$ sudo apt update && apt upgrade -y && sudo apt install -y gyp build-essential g++ libx11-dev libxkbfile-dev libsecret-1-dev python-is-python3 # added gyp

$ which gyp # required by https://www.npmjs.com/package/node-gyp
/usr/bin/gyp

$ dpkg --list gyp # gyp --version isn't supported?
$ Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version                  Architecture Description
+++-==============-========================-============-=====================================
ii  gyp            0.1+20200513gitcaa6002-1 all          Cross-platform build script generator


$ yarn && ./scripts/code-cli.sh  # build takes some time and yarn downloads all(?) the needed dependencies
```

After a few minutes, an electron app popped up and was vscode-like. Surprisingly, the local build isn't connected to the 
[VisualStudio Marketplace](https://marketplace.visualstudio.com/vscode/). Which tells me that Microsoft is tracking vscode usage via extension downloads.
That's might be a "too cynical" view. But "no marketplace" seems opaque enough to 
[wonder why](https://stackoverflow.com/questions/67286826/local-build-of-microsoft-vscode-doesnt-support-its-marketplace-easily).


<!-- @publish: git commit -am "Build vscode From Sources" && git push -->
