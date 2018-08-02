#!/usr/bin/env bash
here=$(readlink -f $(dirname ${BASH_SOURCE}))
blog=$(readlink -f ${here}/../blog)
suffix=${blog##*/}

target=${1:-www-data@do:html/mike.carif.io/html}

(cd ${here}/..; mdbook build)
# scp changes up to blog, url currently hardcoded. Assumes lotsa ssh configuration too.
rsync -ravuc -e ssh ${blog}/ ${target}/${suffix}
# scp -r ${blog} ${target}/${suffix}

# push content to medium
${here}/medium.sh 

# notify the rest of the world
for s in ${here}/notify/*.notify.sh ; do ${s} ; done
