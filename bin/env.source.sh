# usage: `source $(git rev-parse --show-toplevel)/bin/env.source.sh` ## anywhere in git tree
# or `source /path/to/env.source.sh`
me=$(realpath ${BASH_SOURCE})
here=${me%/*}

root=$(git rev-parse --show-toplevel 2>/dev/null)
hooks=$(git rev-parse --git-dir 2>/dev/null)

if [[ -z "$root" ]] ; then
    printf "git root not found, continuing..." > /dev/stderr
else
    if [[ ! -x ${hooks}/post-commit && "${PWD}" != "${here}" ]] ; then
        printf "Configure post-commit hook.\n"
        ln -sr ${hooks}/post-commit ${here}/post-commit
    fi
fi


# Add here to the path so you can run all the bins.
# export PATH=${here}:$PATH
path_if_exists ${here}
(set -x; doctor.sh)
