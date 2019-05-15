#!/usr/bin/env bash
here=$(readlink -f $(dirname ${BASH_SOURCE}))
me=$(readlink -f ${BASH_SOURCE})

title=${1:?'expecting a title'}
html=${2:?'expecting a filename'}
md=$(readlink -e ${here}/..)/src/${html}.md

cat <<EOF > ${md}
---
Author: Mike Carifio &lt;<mike@carif.io>&gt;
Title: ${title}\\
Date: $(date +%F)\\
Tags: #tag0, #tag1\\ 
Blog: [https://mike.carif.io/blog/${html}](https://mike.carif.io/blog/${html})\\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src/${md}](https://www.github.com/mcarifio/blog/blob/master/src/${md})
---

# ${title}

Write Here...
Then: "git commit -am "${title}" && git push"

EOF

summary=${here}/../src/SUMMARY.md
echo "- [${title}](./$(basename ${md}))" >> ${summary}
git add ${md} ${summary}
emacsclient ${md} ${summary}

