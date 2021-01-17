---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Script More, Think Less \
Date: 2020-01-28 \
Tags: #bash #publish #git \ 
Status: committed published
Blog: [https://mike.carif.io/blog/script-more,-think-less.html](https://mike.carif.io/blog/script-more,-think-less.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/script-more,-think-less.md](https://www.github.com/mcarifio/blog/blob/master/src/script-more,-think-less.md)
---

# Script More, Think Less

I periodically experiment with software and systems. Most of it has a "What I Did on My Summer Vacation" quality to it ("I did this, then I did that, then I went here, then I went there."), but I think there are gem's hidden within. But I would think that.

Unfortunately, there's been a little too much ceremony involved in writing a new entry even with some [basic automation](thinking-is-hard.html). 
So I can procrastinate about writing an entry. Writing's hard enough, starting shouldn't be hard. I've now refined this enough that the following workflow ummm works:

```bash
bin/mkentry.sh "Script More, Think Less" # create blog post entry `script-more-think-less.md`
# edit markdown file `script-more-think-less.md`. Say intriguing things.

# ... eventually ...

git commit -a --amend # also publishes _all_ modified entries ...
git push  # in this case to `origin` github
```

The automation has a few "behind the scenes" bonuses:

* The skeleton of the blog entry is displayed at `http://localhost:3000/{{md}}.html`. A browser opens that page in a new tab. 

* Using [`mdbook serve`](https://rust-lang.github.io/mdBook/cli/serve.html), which watches for source file changes in `src` directory of blog posts, 
  every file change regenerates the blog locally for inspection at `http://localhost:3000/{{md}}.html`. Which is conveniently waiting in a browser tab; see previous.

These two operations together makes it easy to review text changes: 1) save the file, 2) review the modifications in the web browser. The next step
would be to couple those two operations. Don't know how yet.



