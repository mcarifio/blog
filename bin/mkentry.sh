#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# Simulate installation. Gross.
shopt -s extglob
[[ -z "${BASHENV}" && -f ~/.bash_login ]] && source ~/.bash_login || true
if [[ -z "${BASHENV}" ]] ; then
    local _xdg_data_home=${XDG_DATA_HOME:-~/.local/share}
    [[ -d ${_xdg_data_home} ]] || { >&2 echo "${xdg_data_home} not found."; return 1; }
    export BASHENV=${_xdg_data_home}
    source ${BASHENV}/load.mod.sh
    path.add $(path.bins)
fi


# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
# trap '_catch --lineno default-catcher $?' ERR

# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--template-flag]=default, --port=4444)
    local -ag _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template-flag]=${_it#--template-flag=};;
            # --template-flag=*) _flags[--template-flag]=${_it#--template-flag=};;
            --port=*) _flags[--port]=${_it#--port=};;
            --) shift; _rest+=($*); break;;
            -*|--*) _catch --exit=1 --print --lineno "${_it} unknown flag" ;;
            *) _rest+=(${_it});;
        esac
        shift
    done

    # echo the command line with default flags added.
    if (( ${_flags[--verbose]} )) ; then
        printf "${_self} "
        local _k; for _k in ${!_flags[*]}; do printf '%s=%s ' ${_k} ${_flags[${_k}]}; done;
        printf '%s ' ${_rest[*]}
        echo
    fi

    # All options parsed (or defaulted). Do the work.
    ${_flags[--forward]}
}



function title2name {
    local title=${1:?'expecting a title'}
    # gross; use sed to convert spaces to dashes and then lowercase the string.
    (sed -E 's/[[:space:]]+/-/g; s/\.//g; s/,//g; s/.*/\L\0/' | tr -d ',!' | tr '[:upper:]' '[:lower:]') <<< "${title}"
}




# Specific work.
function _start-echo {
    declare -Ag _flags _rest
    local _k; for _k in  ${!_flags[*]}; do printf '%s:%s ' ${_k} ${_flags[${_k}]}; done
    echo $*
}

function _start-mkentry.sh {
    local _self=${FUNCNAME[0]}
    declare -Ag _flags
    declare -ag _rest

    local _title=${_rest[0]}
    local _name=$(title2name "${_title}")
    local _md=${_name}.md
    local _mdpath=$(realpath ${_here}/..)/src/${_md}
    local _html=${_name}.html

    # Avoided indented here document because it requires tabs for indentation.
    # https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch03s04.html
    cat <<EOF > ${_mdpath}
---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \\
Title: ${_title} \\
Date: $(date -I) \\
Tags: #tag0, #tag1 \\ 
Blog: [https://mike.carif.io/blog/${_html}](https://mike.carif.io/blog/${_html}) \\
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/${_md}](https://www.github.com/mcarifio/blog/blob/master/src/${_md})
---

# ${_title}

Write Here...

<!-- @publish: git commit -am "${_title}" && git push -->
EOF

    local _summary=${_here}/../src/SUMMARY.md
    echo "- [${_title}](./${_md})" >> ${_summary}
    git add ${_mdpath} ${_summary}
    git commit -m "added ${_mdpath}"
    mdbook serve -p 4444 ${_here}/.. &
    local _port=${_flags[--port]}
    xdg-open http://127.0.0.1:${_port}/${_html}
    echo "git commit --amend # when you've completed ${_mdpath}"
    ec ${_mdpath}
    
}

# skip specific option parsing
# _start_at --start=_start $@

# add specific option parsing
# _start_at --start=_fw_start --forward=_start-${_basename}
_start_at --start=_fw_start --forward=_start-${_basename} $@
