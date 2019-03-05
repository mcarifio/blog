---
Author: Mike Carifio &lt;mike@carif.io&gt;\
Title: ECMAScript Modules (Currently) Considered Harmful\
Date: 2019-03-03\
Tags: #es6, #es2015, #esm, #js, #nodejs, #html5, #modules\
Blog: [https://mike.carif.io/blog/es-modules-considered-harmful.html](https://mike.carif.io/blog/es-modules-considered-harmful.html)
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/es-modules-considered-harmful](https://www.github.com/mcarifio/blog/blob/master/src/es-modules-considered-harmful)
---

# ECMAScript Modules (Currently) Considered Harmful

Javascript and it's more standardized, rigorous cousin ECMAScript, have been around for almost 25 years. That's certainly long enough to have considered code reuse, 
especially on the web, because Javascript started on the web. Yet, like many things Javascript, as on early 2019, modules are in a wierd limbo state, where 
things could work if you fiddle with them long enough, avoid edge cases and foreswear production use, but where the details are confusing and the specifics are elusive.

This should be no surprise. For professional programmers, Javascript is easy to hate. Sloppy or confusing type coercion rules, no reasonable number types and my particular favorite [variable hoisting](https://scotch.io/tutorials/understanding-hoisting-in-javascript) that makes a mockery of lexical scope, js has generated [haters](https://medium.com/javascript-non-grata/the-top-10-things-wrong-with-javascript-58f440d6b3d8) and [apologists](http://shop.oreilly.com/product/9780596517748.do) alike. And as I stand here [on my lawn](https://en.wikipedia.org/wiki/You_kids_get_off_my_lawn!) with my fist raised complaining about those damn Javascript programmers, let me pause to appreciate that 1) js functions are first class, 2) object literals rock and 3) [prototype inheritance](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Inheritance_and_the_prototype_chain) via a "prototype chain" is a powerful concept. Javascript was my first exposure to it.

Certainly I respect and admire the resilence of my Javascript colleagues. Every day brings a new framework. Any given task is automated by at least three or more framework choices. For example, to test your js code (with or without modules, don't worry [the harmful stuff](https://en.wikipedia.org/wiki/Considered_harmful) is coming), you could [investigate](https://medium.com/welldone-software/an-overview-of-javascript-testing-in-2019-264e19514d0a) 20+ frameworks by installing dozens of packages. But first choose your package manager! And then build tool. And webassembler (assuming you're deploying your code to a browser). If choice is good, more choice is better, right? [Not so much](https://en.wikipedia.org/wiki/The_Paradox_of_Choice). If you're going to glue together lotsa stuff, you need good components and good glue. And the Javascriptocracy -- experts at gluing together stuff together for many years -- must surely have that. They do! Four different [module "technologies"](https://spring.io/understanding/javascript-modules), alongside the old fashion script downloading and, of course, minification and bundling. A cornicopia of riches. A sea of confusion. Too many choices without any real integration.

Ok, ok, this is a little harsh. The [CommonJS version of modules](https://flaviocopes.com/commonjs/) was a reasonable response to a language that didn't have modules and the [node package manager](https://www.npmjs.com/) being, well, _node_ and node being, well, _CommonJS_, promoted CommonJS. Or ServerJS. Or something. Of course one of the chief authors of npm [doesn't actually call it CommonJS](https://github.com/nodejs/node-v0.x-archive/issues/5132) -- and he should know -- but everyone else seems to have landed on that name. In 2015, modules were introduced into the ECMAscript specification and promptly implemented in most browsers. Node has "sorta" introduced it. With some shenigans, the `.mjs` file extension, [a special module](https://github.com/standard-things/esm) and the `--experimental-modules` switch, you can finally use the 2015 syntax in your own modules and they should load without modification in both in browsers and in node. The "cool kids" term for this is "isomorphic code" coined as early as 2011 but still inflight, eight years after identifying the concept and four years after it's language standardization.

Pause here. Is there any other programming language you can think of in any "top ten" list that doesn't have a module system that just works? I can only think of one, C++, and there's a proposal for it. Go has something but they want something better. Yes, modules and packaging can be surprising complicated. Javascript code loading, moreover, happens "just-in-time" and asynchronously (at least according to the spec). All this raises the complexity and the stakes. Legacy systems, e.g. node, don't just magically change. But modules have also been studied and implemented since the late 1970's. It's nutty to me that something this basic -- defined in the spec no less! -- just doesn't work without "do-it-yourself" workarounds and experimentation. Is Javascript the first language to add a module system after becoming popular? Nope. Just about every language adds modules and packaging later in response to widespread adoption and use. Only [rust]() paid attention to it from the beginning (and [cargo]() frankly is well done). But its both foundational and important. Get off my lawn, Javacriptoids!

So I'll tell you my workarounds. You might have your own too. Because this is Javascript and the Javascriptocracy likes choice. The goal was and is pretty simple. I wanted to write es6 code (for fun and profit), dividing files up into modules, such that I can load (`<script type="module" src="{{url}}">`) or `import` the same code, without modification, in node and in any web browser (which is chrome and firefox in practice). Whew. Why? I can write the code in one place (the module). Test it with one test suite (starting with importing the module). Utilize the module wherever its needed. And not think much about the "host", client, server or other. 
In other words, use es6 modules as they were intended and specified, isomorophically.

Although I haven't said so -- yet -- I don't want to modify the code "as needed" using a transpiler like babel. I understand babel's value, but this is 2019. Javascript should stand up to modern practices. Babel just makes the complex more complex.

With some luck, this post will soon be obsolete. Es6 modules will "just work" and after learning the language semantics, you can stop thinking about them. Export what your module provides, import what your client needs, package up the module as you see fit, using a bundler for a webbrowser and something else for the server. So, without further adue, here are your heuristics with some [examples](https://github.com/mcarifio/learn-js/tree/master/books/eloquentjs3e):

* On the server side, install a node version >= 10. It will support the `--experimental-modules` switch. Personally, I use [nvm](https://github.com/creationix/nvm) but your platform's package manager probably has node.

* `export NODE_OPTIONS="--require esm --experimental-modules"`. The `--require` switch has just the right touch of irony.

* Install `esm` in your [package.json](https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/package.json). It provides the shim from CommonJS to ES6 (I think).

* Choose a test runner that supports ESM without babel. [ava]() does, [jest]() doesn't. I haven't checked others.

* Don't install babel in the package or globally.

* Turn off babel in (ava.config.js)[https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/ava.config.js#L12] in case it gets installed globally.

* Configure `.mjs` to be considered a module source file wherever its needed, e.g. the test runner. In ava, it's a [config file](https://github.com/avajs/ava/blob/master/docs/06-configuration.md#using-avaconfigjs) (you get choices, natch). I went with the [ava.config.js](https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/ava.config.js#L11) option in case I ever need to switch test runners (which probably will never happen).

* Create modules, name them with `.mjs` extensions, for example https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/src/modules/min.mjs

* Confirm that the "host" doesn't matter by importing your module in various hosts (web browser, node). I've only managed to get the "named" export and 
matching "named" import to work uniformly without code changes (my education continues). Here an example of [html5](https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/src/hosts/clients/html5/min-web-client.html#L9) and [node](https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/src/hosts/servers/nodejs/min-node-client.mjs#L2) consuming and using the same module [min.mjs](https://github.com/mcarifio/learn-js/blob/master/books/eloquentjs3e/src/modules/min.mjs#L14). Who needs [Math.min()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/min)?

This is a lot of work. Handcrafted, tedious work that will probably be repeated by various developers with various variants and choices. Yes, ES6 modules are a little newer, but not bleeding edge either. Something this foundational shouldn't demand a blog post (or I just demonstrated to the world in extended fashion how clueless I can be). That's why I consider ESM currently harmful.


