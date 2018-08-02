# blog

A handcrafted blog using rust's mdbook.

Started with:
```bash

$ rustup update
$ cargo install mdbook
$ git clone git@github.com:mcarifio/blog # you will create your own blog
$ cd blog
$ mdbook init # creates the structure
```

Each time I write a blog entry:
```bash
source bin/env.source.sh  # create a post-commit hook if one doesn't exist
mkmd src/src/some-interesting-tidbit.md

mdbook serve -o # opens browser at http://localhost:3000
emacs src/some-interesting-tidbit.md  ## add a new entry
emacs src/SUMMARY.md  ## enumerate the entry in the list
```

Publish and push:
```bash
git add src/some-interesting-tidbit.md
git commit -a -m "some interesting comment"

publish.sh # if post-commit didn't publish
gnome-open https://mike.carif.io/blog/some-interesting-tidbit.html  ## did it deploy?
git push
announce.sh https://mike.carif.io/blog/some-interesting-tidbit.html

```

# TODO mike@carif.io

* Master emacs's magit for writing this stuff.

* Write `bin\publish.sh` for publishing in bash(?) or rust ion. Bash is a good assumption, but ion is a better scripting language.

