---
Author: Mike Carifio &lt;<mike@carif.io>&gt;
Title: Userscripts
Date: 2019-04-14
Tags: #typescript, #userscript, #greasemonkey 
Blog: [https://mike.carif.io/blog/userscripts.html](https://mike.carif.io/blog/userscripts.html)
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/userscripts.md](https://www.github.com/mcarifio/blog/blob/master/src/userscripts.md)
---

# Userscripts

Well over a decade ago, I experimented with something called [Greasemonkey](https://en.wikipedia.org/wiki/Greasemonkey/) which later Google Chrome called [userscripts](https://www.ghacks.net/2010/02/02/google-chrome-4-natively-supports-greasemonkey-scripts/). For some reason I don't remember having a lot of success writing my own scripts. I seem to remember owning Mark Pilgrim's book [GreaseMonkey Hacks](https://www.amazon.com/Greasemonkey-Hacks-Tools-Remixing-Firefox/dp/0596101651) but never read it (which has been an unfortunate trend). This weekend I took another shot at understanding userscripts and eventually got a hello world style script to run. I did it in typescript. Mostly I struggled with details _surrounding_ userscripts and the usual fragmented and/or dated state of documentation surrounding any technology now. Really, Internet, is it that hard to put everything in one place? Apparently yes.

## A Smoketest

A userscript is a javascript file named `${something}.user.js`, which a webbrowser (firefox, chrome) will treat specially if it has a special extension installed or it's chrome.

Here's an example:

```typescript
// ==UserScript==
// @name         smoketest.user.js
// @namespace    http://mike.carif.io/
// @version      0.1
// @description  smoketest
// @author       Mike Carifio <mike@carif.io>
// testing
// @match        http://0.0.0.0:4500/*
// @match        http://localhost:4500/*
// @grant        none
// ==/UserScript==

// @ require     
// multiple matches allowed


// Need to fix import that works for Deno and client
// import {say} from 'say.ts';

// alert() isn't in node or deno. typescript will complain without a declaration.
// @ts-ignore
declare function alert(...rest:any[]) : void;

function say(m:string, d:Date) {
    return `${m} ${d}`;
}

function main(d: Date, message: string = 'main') : void {
    let response = say(message, d);

    // only works in browser
    try {
        alert(response);
    } catch (e) {
    }

    console.log(response);
}

main(new Date());

```

Note that get (transpile) the associated javascript, you must compile the file above `tsc smoketest.user.ts` to get `smoketest.user.js`:

```javascript
"use strict";
// ==UserScript==
// @name         smoketest.user.js
// @namespace    http://mike.carif.io/
// @version      0.1
// @description  smoketest
// @author       Mike Carifio <mike@carif.io>
// testing
// @match        http://0.0.0.0:4500/*
// @match        http://localhost:4500/*
// @grant        none
// ==/UserScript==
function say(m, d) {
    return `${m} ${d}`;
}
function main(d, message = 'main') {
    let response = say(message, d);
    // only works in browser
    try {
        alert(response);
    }
    catch (e) {
    }
    console.log(response);
}
main(new Date());
```

For completeness, here's `tsconfig.json`:

```json
{
  "compileOnSave": true,  # webstorm will transpile on write
  "compilerOptions": {
    "target": "es2017",                       /* Specify ECMAScript target version: 'ES3' (default), 'ES5', 'ES2015', 'ES2016', 'ES2017', or 'ESNEXT'. */
    "module": "es2015",                       /* Specify module code generation: 'commonjs', 'amd', 'system', 'umd' or 'es2015'. */
    "strict": true                            /* Enable all strict type-checking options. */
  }
}
```

Because the `target` is `es2017`, a fairly modern javascript, the compilation doesn't change the userscript very much. Mostly it removes the type decorations and the `declare` statement.

What's the userscript "special treatment"? 

* The script is loaded but not executed, unlike regular javascript.

* The "comment header" -- the stuff between ` ==UserScript==` and ` ==/UserScript==` -- describe the metadata about when to run the script. See the `@matches` below.

* The script can be loaded with any URL scheme (e.g. `file`, `http`, but _only_ `http(s)` allows for easy reloading when the file changes. It doesn't seem to be automatic
  in chrome _unless_ the script is open in a userscript manager such as [ViolentMonkey](https://violentmonkey.github.io/), which is what I'm using.

* Several `@match` directives describe when the userscript should run, i.e for "matching" urls. The executed code should "know" (parse) how to deal with a page's content.
  _This seems brittle_, although XPath can probably help here.
  
  
## Testing

In my quest to prefer [Deno]() over [node]() when exploring es/typescript stuff, I test `smoketest.user.ts` directly by running it with `deno`. But `ts-node` will work as well.

```bash
$ deno smoketest.user.ts # compilation is automatic on script changes
Compiling file:///home/mcarifio/src/mcarifio/userscript/src/smoketest.user.ts
main Sun Apr 14 2019 22:44:27 GMT-0400 (EDT)
$p ts-node smoketest.user.ts # same code works for node. Modules are treated differently.
main Sun Apr 14 2019 22:44:33 GMT-0400 (Eastern Daylight Time)
```

Once this works, I can run a simple server in `deno` directly (!) with `deno -A https://raw.githubusercontent.com/denoland/deno_std/master/http/file_server.ts`.
This serves up the current directory at `http://0.0.0.0:4500/`. Using chrome, I can load the userscript at `http://0.0.0.0:4500/smoketest.user.js` and then browse `http://0.0.0.0:4500/`. The alert should pop up the date and write the date to the console log (and does both).

## Summary

That was fun.

I've never understood why userscripts don't get more play. Yes, they're clunky. Yes, the javascript of 2005 or even 2010 was ... ummm ... problematic, but we're getting better javascript now with es6+. Typescript is even better. I guess the real issue is that single page applications or web pages are just too complicated. Modifying "the insides" of them by changing HTML elements just isn't sustainable. The content changes and your script breaks. Or worse the website break _only for you_. The risk doesn't seem to justify the benefit. Yet there are many websites that I want to adapt to _my_ needs and not the vendor's needs. The need is real. Userscripts seem like the only game in town right now.
