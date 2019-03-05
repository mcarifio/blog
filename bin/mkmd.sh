#!/usr/bin/env bash
here=$(readlink -f $(dirname ${BASH_SOURCE}))
me=$(readlink -f ${BASH_SOURCE})

name=${1:?'expecting a name'}
md=${here}/../src/${name}.md

cat <<EOF > ${md}
---
Author: Mike Carifio &lt;<mike@carif.io>&gt;
Title: Title
Date: $(date +%F)
Tags: 
Blog: [https://mike.carif.io/blog/${html}](https://mike.carif.io/blog/${html})
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/${md}](https://www.github.com/mcarifio/blog/blob/master/src/${md})
---

# Title

Write here...

EOF

echo "- [title tbs](./$(basename ${md}))" >> ${here}/../src/SUMMARY.md
emacsclient ${md}
