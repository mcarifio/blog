#!/usr/bin/env bash

# Publish (rsync) all modified file to https://mike.carif.io/blog/ "under the covers" over ssh.
# TODO mike@carif.io: best way to make all the hidden configuration information explicit and documented?

me=$(realpath ${BASH_SOURCE:-$0}) # pathname, this script
here=$(dirname ${me}) # script's folder
blog=$(realpath ${here}/../blog) # blog's folder
suffix=${blog##*/} # blog's relative folder, for rsync below
host=$(basename $(realpath ${here}/..)) # hacky, the folder name is also the host target
target=${2:-www-data@do:html/${host}/html} # target of publish as an ssh handle
full_target=${target}/${suffix}
src=$(realpath ${here}/..) # src might _not_ be a child of ${host}

mdbook build ${src}
# changes changes up to `${blog}`
# scp -r ${blog} ${target}/${suffix}
if [[ -z "${PUBLISH_SKIP_UPLOAD}" ]] ; then
    rsync -ravuc -e ssh ${blog}/ ${full_target}
    xdg-open https://${host}/blog
else
    echo "PUBLISH_SKIP_UPLOAD: ${PUBLISH_SKIP_UPLOAD}, skipping upload."
fi


