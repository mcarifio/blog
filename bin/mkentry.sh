#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE})
here=${me%/*}

title=${1:?'expecting a title'}
name=${2:?'expecting a filename'}
md=${name}.md
mdpath=$(realpath ${here}/..)/src/${md}
html=${name}.html

cat <<EOF > ${mdpath}
---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \\
Title: ${title} \\
Date: $(date +%F) \\
Tags: #tag0, #tag1 \\ 
Blog: [https://mike.carif.io/blog/${html}](https://mike.carif.io/blog/${html}) \\
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/${md}](https://www.github.com/mcarifio/blog/blob/master/src/${md})
---

# ${title}

Write Here...

<!-- @publish: git commit -am "${title}" && git push -->
EOF

summary=${here}/../src/SUMMARY.md
echo "- [${title}](./${md})" >> ${summary}
git add ${mdpath} ${summary}
emacsclient ${mdpath} ${summary}

