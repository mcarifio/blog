#!/usr/bin/env bash
here=$(readlink -f $(dirname ${BASH_SOURCE}))
blog=$(readlink -f ${here}/../blog)
suffix=${blog##*/}

target=${1:-www-data@do:html/mike.carif.io/html}

(cd ${here}/..; mdbook build)
# scp changes up to blog, url currently hardcoded. Assumes lotsa ssh configuration too.
# scp -r ${blog} ${target}/${suffix}
rsync -ravuc -e ssh ${blog}/ ${target}/${suffix}
gnome-open https://mike.carif.io/blog

