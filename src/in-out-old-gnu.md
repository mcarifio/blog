---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: (In|Out) x (Old|Gnu)\
Date: 2019-03-05\
Tags: #snap, #snappy, #go, #golang\
Blog: [https://mike.carif.io/blog/in-out-old-gnu.html](https://mike.carif.io/blog/in-out-old-gnu.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/in-out-old-gnu.md](https://www.github.com/mcarifio/blog/blob/master/src/in-out-old-gnu.md)
---

# (In|Out) x (Old|Gnu)


Out with the old, in with the new:

```bash
$ sudo apt-get purge $(dpkg-query -W -f='${binary:Package}\n' | grep -i golang)
$ sudo snap install --classic --channel=1.11/stable go  ## ty Michael Hudson-Doyle
$ cd ~/go/src/carif.io/mcarifio/ghw1
$ go version
go version go1.11.5 linux/amd64
$ type -p go
/snap/bin/go
$ cat ghw1.go 
package main

import (
	"fmt"
	"os"
)

func main() {
	for _, a := range os.Args {
		fmt.Printf("%s ", a)
	}
	fmt.Println()
}
$ go build ghw1.go
$ ./ghw1 in with the gnu
./ghw1 in with the gnu 
```                                                                                     
