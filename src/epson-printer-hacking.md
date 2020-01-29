---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Epson Printer Hacking \
Date: 2020-01-28 \
Tags: #mdns, #print #scan #sane \
Blog: [https://mike.carif.io/blog/epson-printer-hacking.html](https://mike.carif.io/blog/epson-printer-hacking.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/epson-printer-hacking.md](https://www.github.com/mcarifio/blog/blob/master/src/epson-printer-hacking.md)
---

# Epson Printer Hacking

I do just enough printing and scanning to justify owning a printer, but I also sulk about the costs because I don't print or scan _that_ much.
Moreover, Linux support for printing or scanning has always lagged behind Windows and OSX (as does much device support, especially sound). It has improved and
continues to do so. But it's always just a little bit behind. The other platforms are more convenient and do more _stuff_, e.g. reporting ink levels or initiating a scan from
the scanner itself, not the computer. I had limped along an Epson XF-420 which I purchased in 2015 to scan some employment forms. It was a serviceable unit,
but the ink cartridges added up and when I was forced to clean the ink dispensers a third time to print anything, the 420 became a "hand-me-down" to my son. It's
the perfect name. He can unclog the ink sprayers.

The new printer, an [ET-3760](https://www.amazon.com/gp/product/B07NK8PM4D/ref=ppx_yo_dt_b_asin_title_o00_s01), has a few useful features. Instead of the expensive
cartridges, ink is stored in reserviors, which can be periodically refilled. Although I'd classify the ET as a "mid-range" printer, it supports network _and_ usb printing simultaneously. The network can be either wired (ethernet) or wireless (802.11 b/g/n), but not both at once. That seems a little counterproductive. 
You have two different hardware adapters. Is enabling both that difficult?

The printer supports multicast DNS (mdns) -- called Bonjour in Apple circles -- so the printer can be accessed with a memorable name, 
e.g. `et-3760.local` after a little configuration. This doesn't play prominently when discovering new printers on a LAN but could play a later role when
configuring across routers. We'll see.

The unit's a little pricey side for an ink jet printer, but eventually you will break even from the ink. Depends on printing frequency. Not much for me. So the break even is several years into the future.

You can also scan "over the network", although not directly. You basically scan to an intermediary that connects to the scanner via usb. I didn't need a new printer with mdns to make that work. I just never got around to configuring it with the old printer. `scp` gets you 90% of the way there, but now -- fun, fun, fun -- I can scan directly to several computers. I will have to remind myself which configuration file to change (`/etc/sane.d/net.conf`) when I get a new device. Which won't be this year. 

<!-- @publish: git commit -am "Epson Printer Hacking" && git push -->
