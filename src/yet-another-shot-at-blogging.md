# Yet Another Shot At Blogging

From: Mike Carifio <mike@carif.io> 
Date: 2018-08-01
Subject: Yet Another Shot At Blogging

I've always been a reluctant blogger. It seems ostentacious and showy. Good writers don't waste your time with their drivel and it's _really_ drivel if you don't write, 
write more and rewrite. Who has time for that? As Hawthorne said "Easy reading is damn hard writing."

Apparently I do. Especially in technical circles to be a credible senior technologist and/or thought leader, you need to blog. I'm fine with that, 
but you, Good Reader, may not be ... be forewarned. If I feel forced to do this, at least my hope is to rise to the occasion and write some things that are useful,
correct, perhaps even insightful. There are some really good blogs out there, that I've learned from, even if they are semi-transparent marketing devices. Providing value is no small feat, providing
insight is harder still. But that's ok. You got here with a click, you can leave the same way. Please close the door when you leave.

Paul Graham wrote something recently that stuck with me about [insight vs novelty](http://www.paulgraham.com/sun.html). I'm paraphrasing here but gossip is surprising without being general and 
platitudes are general without being surprising. Besides being wise, it was damn hard writing. In just a few sentences, he raised the bar.

So, since I don't have something really useful to describe, I'll tell you the mechanics of how this blog works. And why.

I've tried this twice before. The first time around, I wrote the pages directly using emacs in html. This is was a _long_ time ago, when cascading stylesheets where still in development and javascript was a thing, but not a framework.
I edited files directly "in-place" at the server. Needless to say, this Took Discipline and also needless to say was pretty sporadic. But it was a website and I was writing pages. I'm not even sure blogs were a thing with a word at that point.
Lord knows no one read any of it.

About four years ago, I gave it another go with Wordpress. Writing was somewhat easier (but not in emacs) and the result looked _far_ better with little work. And I had comments for free! And lotsa spam for free! I wrote a few fun things, had a few fun
comments from friends, but eventually got distracted by the next shiny thing.

So here we are, third times a charm. This time around I'm giving it a little more thought. First, I'm using emacs again, the One True Editor. I'm writing in Markdown (which is mostly text) and not HTML (which is mostly markup). I'm using the (so far) wonderful
[mdbook](https://github.com/rust-lang-nursery/mdBook), which can build the blog "on the fly" without thinking about it. I'm using [github](https://github.com/mcarifio/blog) to save drafts before publishing them with 
a do-it-yourself [publisher](https://github.com/mcarifio/blog/blob/master/bin/publish.sh). Seems a little hacky, but it will evolve and it has a programmer's workflow. 




