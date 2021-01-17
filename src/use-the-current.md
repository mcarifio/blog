---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Use The Current \
Date: 2021-01-17 \
Tags: #wayland, #nvidia, #ati, #drivers, #wisdom \ 
Blog: [https://mike.carif.io/blog/use-the-current.html](https://mike.carif.io/blog/use-the-current.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/use-the-current.md](https://www.github.com/mcarifio/blog/blob/master/src/use-the-current.md)
---

# Use The Current (Don't Fight it)

I've been a Unix/Linux user for many years, starting with a forced conversion at Digital Equipment Corporation in 1986 at the behest of my manager's manager. 
His strategic intent: to service other vendor's computers as well as DEC's, most of which used Unix rather than Digital's VMS operating system. It was a prescient
idea. It failed. Although I didn't realize it at the time, I bore witness to the Peter Drucker saying that "culture eats strategy for breakfast." 
For my part, I learned Unix and have used it more or less since then, moving over to Linux ... err, GNU/Linux ... around 1993 when Redhat came on five(ish) floppy disks. I also
spent a lot of time on Windows NT, but struggled with the Microsoft programming model and tools until C# came along. And although I respect Microsoft's technical acumen,
I respect their business acumen more. Despite cultivating developers, they always made the money when you were learning their tools as their ummm "partner".

I went all-in on Linux around 2005 when I realized that's where all my revenue was coming from despite the technical "superiority" of Windows and even Macs. I owned a Mac workstation for 
several years to see how the other half lived (nicely it turns out) and to help my daughter with computer questions since she used a Mac laptop at (middle) school. She never needed my help and the machine
was an expensive luxury (one of several machines I purchased with the intent of forcing myself to use it to learn. Nope. Done that with many books as well.)

Although I have an advanced degree in Computer Science, my hardware knowledge was always self-taught through experimentation and really mostly breaking things. When modems were "a thing", I opened up
my first personal computer and installed one. I remember it taking days, mostly because I didn't know what I was doing, Windows wasn't "seeing" the modem and I couldn't understand why. I _do_
remember reading a lot of gibberish of INT this and IRQ that and understanding the concepts but not getting anything to actually, you know, _work_. Then came installing sound cards for my son to play
Oregon Trail, a game he loved. Oh my. I remember reading an article written in a trade magazine opining that sound was the dirty little secret of the industry. No one could actually get it
to work. Perhaps a little overwrought, but I certainly struggled ... and I thought it was just me. When the Nintendo 64 came out, I purchased one for Christmas for my kids mostly so I could escape soundcards
(but it was not to be).

In recent years, my hardware travails have surrounded NVidia graphics cards and multiple monitors. Oh I still having screaming fits with computer sound -- Pulseaudio --  mostly because usb headphones aren't recognized or are silent despite being selected. I've purchased several headphones based entirely on their ability to connect to Linux without configuration. Doesn't seem to matter. I still use 3.5mm jacks because they actually seem to work. Pulseaudio sucks, but I can live without sound if I must. I can't live without a display. Of course, because I stare at a screen most every day for an extended period, I'm willing to spend a few more dollars for a richer experience: faster graphics, better framerates, higher resolution (within reason). So I've chosen NVidia graphics cards. This has proven to be ummm problematic.
I had the grave misfortune of a few laptops with nvidia hardware inside. One had a "combo arrangement" where you could engage the nvidia driver "on demand" with something called "NVidia Prime". Ugh.
Never worked. Later I got a few of the higher end GeForce cards. Which had great performance and broke on every revision of the my distribution, twice a year. This forced me to learn a few things about X Windows, the Gnone Display Manager and gnome-shell. But Wayland was off limits.

Over the weekend, I finally stopped banging my head against the NVidia wall. I installed an AMD Firepro W7100. It wasn't cheap but it wasn't cutting edge NVidia ... or AMD for that matter. But here's what it really was: simple to install, booted correctly on the first try, with a multimonitor configuration _without_ any driver installation and with Wayland. So the overall experience matters. This includes finding the drivers, installing them, configuring them and diagnosing their issues as needed. When each of those operations takes zero time, I think one can sacrifice a little hardware performance. Perhaps
NVidia might start getting the message and contribute to better Linux drivers. Or not. If that happens, and the experience gets better, good for them, I will enjoy a wide range of choices. That's always
a good thing. But I'm not planning on it. At best, it's years away. In the meantime, I'll use the time I would have dedicated to fixing NVidia problems for important stuff. Like Pulseaudio.


<!-- @publish: git commit -am "Use The Current" && git push -->
