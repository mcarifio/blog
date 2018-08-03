---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: Yet Another Shot At Blogging\
Date: 2018-08-01\
Tags: blog, rust, mdbook, magit, emacs, again\
Blog: [https://mike.carif.io/blog/yet-another-shot-at-blogging.html](https://mike.carif.io/blog/yet-another-shot-at-blogging.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/yet-another-shot-at-blogging.md](https://www.github.com/mcarifio/blog/blob/master/src/yet-another-shot-at-blogging.md)xs
---

# Yet Another Shot At Blogging

I've always been a reluctant blogger. It seemed ostentacious and showy. Good writers don't waste your time with their drivel and it's _really_ drivel if you don't write, 
write some more and rewrite that. As Hawthorne said "Easy reading is damn hard writing." Who has time for that? 

Apparently I do. In technical circles to be a credible senior technologist and/or thought leader, you need to blog, the industry version of the academic's "publish or perish." I'm fine with that, 
but you, Good Reader, may not be ... be forewarned. If I feel forced to do this, at least my hope is to rise to the occasion and write some things that are useful,
correct, perhaps even insightful. There are some really good blogs out there, that I've learned from, even if they are semi-transparent marketing devices. Providing value is no small feat, providing
insight is harder still. But that's ok. You got here with a click, you can leave the same way. Please close the window (or tab) when you leave.

Paul Graham wrote something recently that stuck with me about [insight vs novelty](http://www.paulgraham.com/sun.html). I'm paraphrasing here but gossip is surprising without being general and 
platitudes are general without being surprising. The bull's eye is novel (new) insight. Besides being wise, it was damn hard writing. In just a few sentences, he raised the bar.

So, since I don't have something newly insightful, I'll tell you the mechanics of how this blog works. And why. One reason I haven't blogged (besides the damn hard writing) is that I never found a system that worked for me.
_System_ here means a tool I enjoyed writing with and lets me focus on the content and not the encoding, with free, flexible and convenient tools where I can craft my own workflow and (key point) I can deploy myself. There
are many great blogging platforms and I might eventually target a few. But my tools should adapt to me, not me adapt to the tools. Many blogging platforms making writing a little harder to make publishing a little easier, even if
online writing tools (editors) have gotten way better. The desktop may be giving way to smartphones with millenials, but emacs and a keyboard still rule with this dinosaur.

I've tried blogging twice before. The first time around, I wrote the pages directly using emacs in html _on a server_. This is was a _long_ time ago, when cascading stylesheets were still in development and javascript was a thing, but not a framework.
I edited files directly "in-place." Needless to say, this Took Discipline and also needless to say that discipline was pretty sporadic. But it was a website and I was writing pages. I'm not even sure blogs were a thing with a word at that point.
Lord knows no one read any of it. Which is just as well because it saved me some shame.

About four years ago, I gave it another go with [Wordpress](https://www.wordpress.com/). Writing was somewhat easier (but not in emacs) and the result looked _far_ better with about the same amount of work. 
And I had comments for free! And lotsa comment spam for free! I wrote a few fun things, had a few fun comments from friends, but eventually got distracted by the next shiny thing. I recently switched hosting vendors and inadvertently destroyed
the site.

So here we are, third times a charm. This time around I'm giving it a little more thought. First, I'm using emacs again, the One True Editor, with it's equally wonderful [magit](https://magit.vc/) and mark-down mode. 
I'm writing in Markdown (which is mostly text) and not HTML (which is mostly markup). I'm using the (so far) wonderful [mdbook](https://github.com/rust-lang-nursery/mdBook), which can build the blog "on the fly" without thinking about it.
Well, not quite; `mdbook` is actually intended for books and technical documentation, not blogs. But a blog is just a book that unfolds over time, yes?
I'm using [github](https://github.com/mcarifio/blog) to save drafts before publishing them with a do-it-yourself [publisher](https://github.com/mcarifio/blog/blob/master/bin/publish.sh) script.The script will grow.
All this now seems a little hacky, but it will evolve and it has a programmer's workflow. I'll describe its evolution as it unfolds. Might be fun.





