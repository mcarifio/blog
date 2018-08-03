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
emacsclient $(mkmd.sh some-interesting-tidbit) src/SUMMARY.md ## edit the new entry
mdbook serve -o # opens browser at http://localhost:3000
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


