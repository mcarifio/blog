# usage: `source $(git rev-parse --show-toplevel)/bin/env.source.sh` ## anywhere in git tree
# or `source /path/to/env.source.sh`

if ! root=$(git rev-parse --show-toplevel 2>/dev/null) ; then printf "git root not found, continuing..." > /dev/stderr ; fi
here=$(readlink -f $(dirname ${BASH_SOURCE}))
export PATH=${here}:$PATH
printf "${here} added to path\n"
printf "Test the search path by running the "doctor.sh" script (which tests the environment)\n"
( set +x; doctor.sh )
