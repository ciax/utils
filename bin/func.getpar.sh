#!/bin/bash
# Option parse module
# Usage:
#  souce $0 at head of file,
#  set opt-?() or xopt-?() functions,
#  _usage()
#  _exe_opt()
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
# Option List (set to $opts and $items)
_mk_optlist(){ # List of options with opt-?() functions
    local line fnc opt desc
    while read line;do
        fnc="${line%%(*}"
        [[ "$line" =~ '#' ]] && desc=":${line#*#}"
        opt=${fnc#*opt-}
        opts=$opts$opt
        items=$items$C2"$opt$C0${desc/:=/=}\n"
    done < <(egrep '^x?opt-.\(\)\{' $0)
}
# Show Usage
_disp_usage(){
    local opts items
    _mk_optlist
    echo -e "Usage: $C3${0##*/}$C0${opts:+ (-$opts)} $1" 1>&2
    echo -e $items|grep .|_indent
}
# Usage: _usage [par_txt] (arg list)
# Desctiption
#   1. Execute xopt-?() and exit as an exclusive function if exist.
#   2. Check the single options that provided as opt-?() or xopt-?() functions.
#   3. Check the number of arguments (ARGC >= The count of '[' in parlist)
#   4. Check the value of argument whether it is in args following parlist 
#   5. Execute opt-?() functions at _exe_opt().
# Parameter Text format:
#   option is automatically printed as "(-x,-y..)"
#   option with parameter => -x=par
#   mandatory parameters => enclosed by "[]"
#   file name replaceable with stdin => enclosed by "<>"
#   optional parameters => enclosed by "()"
# -n: No display valid pars and return only 
_usage(){ # Show usage
    _exe_xopt
    _chk_all "$@" && return # because it includes '[]'
    _disp_usage "$1";shift
    for i;do echo $i;done | _colm 1>&2
    exit 1
}
_chkfunc $*
# Option Parser
declare -a ARGV
declare -a OPT
for i;do
    case "$ARGV$i" in
        -*) OPT=("${OPT[@]}" "$i");;
        *) ARGV=("${ARGV[@]}" "$i");;
    esac
    shift
done
ARGC=${#ARGV[@]}
set - "${ARGV[@]}"

