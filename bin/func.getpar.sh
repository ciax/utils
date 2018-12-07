#!/bin/bash
# Option parse module
# Usage:
#  souce $0 at head of file,
#  set option functions [opt-?() or xopt-?()],
#  _usage()
#  _exe_opt()
type _usage >/dev/null 2>&1 && return
. func.list
# Option Handling
_exe_xopt(){ # Exclusive option handling
    local i
    for i in ${OPT[*]};do
        if type -t "xopt${i%%=*}" &>/dev/null; then
            xopt${i//=/ }
            exit
        fi
    done
}
_exe_opt(){ # Option handling, don't forget to execute after _usage
    local _executed=1
    for i in ${OPT[*]};do
        type -t "opt${i%%=*}" &>/dev/null && opt${i//=/ }
        _executed=0
    done
    return $_executed
}
_ver_func(){ # Verify function
    if egrep -q "^opt-.\(\)\{" $0 && ! egrep -q "_exe_opt" $0; then
        _alert "_exe_opt() is missing!"
        return 1
    fi
}
# Check Arguments
_chk_opt(){ # Check options
    local i
    for i in ${OPT[*]};do
        type -t "opt${i%%=*}" &>/dev/null && continue
        _alert "Invalid option ($i)"
        return 1
    done
}
_chk_argc(){ # Check the argument count
    local reqp="$1"
    local reqc="$(IFS=[;set - $reqp;echo $(($#-1)))"
    [[ "$reqp" =~ '<' ]] && [ -t 0 ] && reqc=$(($reqc+1))
    [ "$ARGC" -ge "$reqc" ] || { _alert "Short Argument"; return 1; }
}
_chk_argv(){ # Check the argument value
    [ "$1" ] || return 0
    local _i
    for _i in ${ARGV[*]} ;do
        local ng=1 ex
        for ex; do
            [ $_i = $ex ] && unset ng
        done
        if [ "$ng" ]; then
            _alert "Invalid argument ($_i)"
            return 1
        fi
    done
}
_chk_all(){ # Check all argument
    local reqp=$1;shift
    _ver_func && _chk_opt && _chk_argc "$reqp" && _chk_argv $* && return
}
# Option List
_optlist(){ # Pack of option letters of opt-?() functions
    local line fnc opts
    while IFS='-(#' read _ opt _ desc;do
        opts+=$opt
        OPTDEF+=("-$opt$(__optdesc "$desc")")
    done < <(egrep '^x?opt-.\(\)\{' $0)
    echo -n "${opts:+ (-$opts)}" 1>&2
}
__optdesc(){
    # pre colon gets into key (i.e. -o{ #=tag:desc -> -o=tag,desc) 
    [[ $1 =~ =(.+): ]] &&  echo -n ${1/=*:/=${BASH_REMATCH[1]},} || echo -n ",$1"
}
# Case List
_caselist(){ # List of case option
    egrep -o '^ +[a-z]+\)' $0|tr -d ' )'
}
_caseitem(){ # List of case desctiption
    local line arg
    egrep '^ +[a-z]+\)' $0 |\
    while read line;do
        arg="${line%%)*}"
        echo -n "${arg#* }"
        [[ "$line" =~ '#' ]] && echo ",${line#*#}" || echo
    done
}
# Usage: _usage [par_txt] (arg list)
# Description
#   1. Execute xopt-?() and exit as an exclusive function if exist.
#   2. Check the single options that provided as opt-?() or xopt-?() functions.
#   3. Check the number of arguments (ARGC >= The count of '[' in parlist)
#   4. Check the value of argument whether it is in args following parlist 
#   5. Execute opt-?() functions at _exe_opt().
#   6. Option function name will be followed by a comment to show description.
# Parameter Text format:
#   option is automatically printed as "(-xy..)"
#   option with parameter => -x=par
#   mandatory parameters => enclosed by "[]"
#   file name replaceable with stdin => enclosed by "<>"
#   optional parameters => enclosed by "()"
# -n: No display valid pars and return only 
_usage(){ # Check and show usage
    _exe_xopt
    _chk_all "$@" && return # because it includes '[]'
    grep '^# *Description' $0 | sed 's/# *//' 1>&2
    _disp_usage "$1";shift
    for i;do echo $i;done | _colm 40 1>&2
    exit 1
}
_disp_usage(){
    echo -en "Usage: $C3${0##*/}$C0" 1>&2
    _optlist
    echo -e " $1" 1>&2
    shift
    for i in "${OPTDEF[@]}";do echo "$i";done | _colm 1>&2
}


_chkfunc $*
# Option Parser
declare -a ARGV
declare -a OPT
declare -a OPTDEF
for i;do
    case "$ARGV$i" in
        -*) OPT+=("$i");;
        *) ARGV+=("$i");;
    esac
    shift
done
ARGC=${#ARGV[@]}
set - "${ARGV[@]}"
