---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Discovering Jsonnet \
Date: 2020-01-29 \
Tags: #json #jsonet #data #transfer \ 
Status: draft \
Blog: [https://mike.carif.io/blog/discovering-jsonnet.html](https://mike.carif.io/blog/discovering-jsonnet.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/discovering-jsonnet.md](https://www.github.com/mcarifio/blog/blob/master/src/discovering-jsonnet.md)
---

# Discovering Jsonnet

The Javascript Object Notation ([JSON](https://www.json.org/)), according to it's website, is a "lightweight data-interchange format. It is easy for humans to read and write. It is easy for machines to parse and generate." Two out of three isn't bad. It's certainly "light weight." The syntax is easy to summarize using so-called ["McKeeman Form"](https://www.crockford.com/mckeeman.html), a simplified Backus-Naur Form. MF is visually clean in the same way [python](https://www.python.org/) is visually clean, using indentation to connote nesting. Also has a cool acronym. It's also easy for _machines_ to parse and generate. Every programming language seems to have JSON support, either built-in or installable via a package. It may be easy for humans to read and write, but it sure is tedious. Humans -- or at least programming humans -- don't naturally "think json". They ["think different"](https://en.wikipedia.org/wiki/Think_different) (to steal some branding).

Everyone has their favorite "missing feature" or annoyance: 1) no comments, 2) quoted keys, 3) trailing commas, 4) _any_ commas and 
5) missing data types like dates or datetimes. The [list](https://news.ycombinator.com/item?id=12327668) goes on and geeks gonna geek. 
And create variants: [toml](), [ini](), [yaml](), [hjson](), [json5](), [json6](), [jsox](https://github.com/d3x0r/jsox), 




<!-- @publish: git commit -am "Discovering Jsonnet" && git push -->
