---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Selecting a (GNOME) window by Name \
Date: 2020-02-07 \
Tags: #gnome, #alt-tab #gnome-extension \ 
Blog: [https://mike.carif.io/blog/selecting-a-gnome-window-by-name.html](https://mike.carif.io/blog/selecting-a-gnome-window-by-name.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/selecting-a-gnome-window-by-name.md](https://www.github.com/mcarifio/blog/blob/master/src/selecting-a-gnome-window-by-name.md)
---

# Selecting a (GNOME) window by Name

I use the terminal program [Terminator](https://launchpad.net/terminator/gtk3/1.91) for my daily Linux (Ubuntu, Fedora) use. Unfortuately, it has a flaw, which might be a Terminator flaw or a GNOME flaw, I haven't figured out which (and I haven't spent a lot of time pinning the blame). If you have multiple Terminator windows open to various hosts, each window is labeled `Terminator` with nothing to distinguish them while switching applications using `alt+tab`. I had tried various ways to distinguish the windows using various switches like `--role` and `--classname`. I looked at alternative application switchers for GNOME. A lot of deadends. Then I happened upon the GNOME extension [switcher](https://extensions.gnome.org/extension/973/switcher/). I couldn't use the UI based methods for installation, since Ubuntu itself is having some GNOME extension issues. So I installed it manually using the command line. It was a better experience:

```bash
mkdir -p ~/.local/share/gnome-shell/extensions
cd ~/.local/share/gnome-shell/extensions
git clone https://github.com/daniellandau/switcher.git switcher@landau.fi
gnome-extensions enable switcher@landau.fi

# dconf save (and remove) the current binding for `switch applications` at the command line.
dconf read /org/gnome/desktop/wm/keybindings/switch-applications > org.gnome.desktop.wm.keybindings.switch-applications.txt
dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['disabled']"
dconf write /org/gnome/shell/extensions/switcher/show-switcher "['<Alt>Tab']" # creates the key and assigns the value
gnome-shell --replace # get the switcher above
```
When the shell restarts, you get the behavior summarized in the switcher's [README.md](https://github.com/daniellandau/switcher/blob/master/README.md) with the addition that the default GNOME switcher has been superceded. It will take a little bit of effort to modify my finger memory with this new switcher. But switching by name with better window titles is well worth the effort.

<!-- @publish: git commit -am "Selecting a (GNOME) window by Name" && git push -->
