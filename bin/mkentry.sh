#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE})
here=${me%/*}

function title2name {
    local title=${1:?'expecting a title'}
    # gross; use sed to convert spaces to dashes and then lowercase the string.
    sed -E 's/[[:space:]]+/-/g ; s/.*/\L\0/' <<< "${title}"
}


title="${1:?'expecting a title'}"
name=${2:-$(title2name "${title}")}
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
git commit -m "added ${mdpath}"
mdbook serve &
xdg-open http://127.0.0.1/${html}
echo "git commit --amend # when you've completed ${mdpath}"
ec ${mdpath} ${summary}

