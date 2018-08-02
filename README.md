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
source bin/env.source.sh
mdbook serve -o # opens browser at http://localhost:3000
emacs src/some-interesting-tidbit.md  ## add a new entry
emacs src/SUMMARY.md  ## enumerate the entry in the list
```

Publish and push:
```bash
publish.sh # tbs
gnome-open https://mike.carif.io/blog

git add src/some-interesting-tidbit.md
git commit -a -m "some interesting comment"
git push
```

# TODO mike@carif.io

* Master emacs's magit for writing this stuff.

* Write `bin\publish.sh` for publishing in bash(?) or rust ion. Bash is a good assumption, but ion is a better scripting language.

