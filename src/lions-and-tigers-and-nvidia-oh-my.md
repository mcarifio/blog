---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Lions and Tigers and Nvidia, Oh My! \
Date: 2020-03-02 \
Tags: #tag0, #tag1 \ 
Blog: [https://mike.carif.io/blog/lions-and-tigers-and-nvidia-oh-my.html](https://mike.carif.io/blog/lions-and-tigers-and-nvidia-oh-my.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/lions-and-tigers-and-nvidia-oh-my.md](https://www.github.com/mcarifio/blog/blob/master/src/lions-and-tigers-and-nvidia-oh-my.md)
---

# Lions and Tigers and Nvidia, Oh My!

Summary: [Nvidia's](https://www.nvidia.com/en-us/drivers/unix/) drivers continue to periodically break my desktop linux machine(s). 
But Nvidia just happens to be posterchild of more deepseated [technical](http://itvision.altervista.org/why.linux.is.not.ready.for.the.desktop.current.html) -- and economic -- 
issues in computing and open source. Nonetheless, [Nvidia stills does suck](https://arstechnica.com/information-technology/2012/06/linus-torvalds-says-f-k-you-to-nvidia/)
and I won't be purchasing their hardware anymore. (Of course, until I do.)

First, a short tale of woe. Then some commentary.

On my long list of "get to it" items, I had wanted to improve my screencasting skills with [vokoscreen](). A new version just shipped -- [vokoscreenNG]() -- which redoes much of the architecture. Screencasting has many uses: demos, quality assurance, live programming, pair programming and training. But for me anyways, doing it on Linux has turned into a science project, so I haven't invested the time. VokoscreenNG might change that, but first I had to install it and try it.

Screencasting on Linux generally requires X Windows (oh, oh). I guess to "get at" the frame buffer and convert it into a video frame. I'll need to research this more. Although the anticipated X replacement Wayland might also fit into this picture, Nvidia doesn't seem to work with Wayland. And this generates [a bit of heat](https://news.ycombinator.com/item?id=19128420). I'll return this fire below in a few paragraphs. I would suffer through Wayland's maturation if I could avoid X, but that cure seems worse than the affliction.

I've been computing long enough that I pre-date X Windows. I even pre-date "video display units" (VDUs). Both were "eye opening" when I first saw them. 
And I understand the gist of X pretty much although I find the separation of parts confusing. The server is a user space program, but the manages display devices, keyboards, mice, audio and so forth, which are kernel resources. The window manager is separate. The "compositor" is separate as well. Each graphics device has its associated driver although a driver may support multiple cards in a family. The X configuration file is confusing, but it's also a thing of the past. I never touch it now.

When I upgraded the Nvidia drivers on Fedora 31, I was also running Wayland as the graphics server. As a result, I was never _actually_ using the Nvidia hardware! 
I was using the Intel device. Worked just fine. Until I decided to actually use X explicitly for vokoscreenNG. 
I got a nice blank screen for my effort, as usual when touching anything X related. 
I eventually upgraded the Nvidia driver to a more recent version after enabling an external Fedora repository, installing and then rebooting. It was experimentation, googling and cursing. Yet I count myself lucky to have X spin up after only a few hours lost to debugging. I've lost upwards of a day in some cases and those cases happen too frequently, maybe a few times each year. That's just often enough to exasperate me, but not so often to invest reading time to refine my understanding of X. 
Nevertheless, I usually fix the problem, whether on Fedora or Ubuntu -- and perhaps learn a little along the way.

    That recent drivers were _not_ in the core Fedora repository makes little sense. Yes, Fedora is a community project composed of volunteers and owe me nothing. But 



<!-- @publish: git commit -am "Lions and Tigers and Nvidia, Oh My!" && git push -->
