#!/usr/bin/env bash
here=$(readlink -f $(dirname ${BASH_SOURCE}))
me=$(readlink -f ${BASH_SOURCE})

md=${1:-src/entry-$(date +%F).md}

cat <<EOF > ${md}
---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: Title\
Date: $(date +%F)\
Tags: 
Blog: [https://mike.carif.io/blog/$(basename ${md} .md).html](https://mike.carif.io/blog/$(basename ${md} .md).html)
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/${md}](https://www.github.com/mcarifio/blog/blob/master/src/${md})
---

# Title

Write here...

EOF

echo "- [title](./$(basename ${md}))" >> ../src/SUMMARY.md
echo ${md}
