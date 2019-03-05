---
Author: Mike Carifio &lt;<mike@carif.io>&gt;
Title: eman: Anatomy of a Hack
Date: 2019-02-19
Tags: 
Blog: [https://mike.carif.io/blog/eman.html](https://mike.carif.io/blog/eman.html)
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/eman](https://www.github.com/mcarifio/blog/blob/master/src/eman)
---

# eman: Anatomy of a Hack

You may be surprised to learn that like many software developer types I have documentation to this or that open all the time. 
Web brower(s), lotsa `--help` switches on commands, `describe-*` in emacs, `Quick Documentation` in the Intellij IDEs, and
of course, the venerable `info` and more venerable `man` commands. Can't have enough good information and your fingertips.

Man in particular is wonderfully convenient and terse. You're tying in a command, forget a switch and `man <command>`. Except that the man page is
presented in the shell itself. `yelp man:<command>` can solve that problem. But not in `tmux` up at Amazon. So here's a simple hack:




