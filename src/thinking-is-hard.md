---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Thinking is Hard \
Date: 2019-05-15 \
Tags: #git, #mdbook, #automation \
Blog: [https://mike.carif.io/blog/thinking-is-hard](https://mike.carif.io/blog/thinking-is-hard) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/src/thinking-is-hard.md](https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/src/thinking-is-hard.md)
---

# Thinking is Hard

Writing blog entries:

```bash
/path/to/bin/mkmd.sh "Thinking is Hard" thinking-is-hard
# write in emacs, save file
git commit -am 'Thinking is Hard' && git push
```

The script `mkmd.sh` creates a "starter md file" in the right location with the header values above. It also updates an index file `SUMMARY.md` consistent with rust's `mdbook` command. Finally it adds the new or modified files to the git index, so that `git commit -a` will sweep them up later. The commit also has a hook that pushes the changes to my [blog](https://mike.carif.io/blog/thinking-is-hard.html). `git push` moves them off my machine.

I might redo this in emacs-lisp, but that embeds emacs itself as a dependency. Can't imagine using another editor, but I also shouldn't pollute the script. That said, I should do the git operations in [`magit`](https://magit.vc/). More keybindings to memorize.

