#!/bin/bash
# Option parse module
# Usage:
#  souce $0 at head of file,
#  set opt-?() or xopt-?() functions,
#  _usage()
#  _exe_opt()
. func.temp
_list_cols(){ # Show folded list
    local size=0
    local tmplist
    local item
    local line
    _temp tmplist
    while read item;do
        [ "${#item}" -gt $size ] && size="${#item}"
        echo "$item"
    done > $tmplist
    while read item;do
        [[ "$item" =~ , ]] && item="$C2${item/,/$C0: }"
        while [ ${#item} -lt $size ]; do
            item="$item "
        done
        line="$line\t$item"
        if [ "${#line}" -gt 40 ] ; then
            echo -e "${line% *}"
            unset line
        fi
    done < $tmplist
    [ "$line" ] && echo -e "$line"
}
_caselist(){ # List of case option
    local line
    local arg
    egrep '^ +[a-z]+\)' $0 |\
    while read line;do
        arg="${line%%)*}"
        echo -n "${arg#* }"
        [[ "$line" =~ '#' ]] && echo ",${line#*#}" || echo
    done
}
_optlist(){ # List of options with opt-?() functions
    local line
    local fnc
    local desc
    egrep '^x?opt-' $0|\
    while read line;do
        fnc="${line%%(*}"
        [[ "$line" =~ '#' ]] && desc=":${line#*#}"
        echo $C2"${fnc#*opt}$C0${desc/:=/=}"
    done
}
_chkopt(){ # Check options
    local i
    for i in ${OPT[*]};do
        type -t "opt${i%%=*}" &>/dev/null && continue
        _alert "Invalid option ($i)"
        return 1
    done
}
_exe_xopt(){ # Exclusive option handling
    local i
    for i in ${OPT[*]};do
        if type -t "xopt${i%%=*}" &>/dev/null; then
            xopt${i//=/ }
            exit
        fi
    done
}
_chkargc(){ # Check the argument count
    local reqp="$1"
    local reqc="$(IFS=[;set - $reqp;echo $(($#-1)))"
    [[ "$reqp" =~ '<' ]] && [ -t 0 ] && reqc=$(($reqc+1))
    [ "$ARGC" -ge "$reqc" ] || { _alert "Short Argument"; return 1; }
}
_chkargv(){ # Check the argument value
    local i=0
    local file
    for file;do
        grep -q "${ARGV[$i]}" "$file" || {
            _alert "Invalid argument (${ARGV[$i]})"
            return 1
        }
        i=$(($i+1))
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

# Usage: _usage [parlist] (list files)
# Desctiption
#   1. Execute xopt-?() and exit as an exclusive function if exist.
#   2. Check the single options that provided as opt-?() or xopt-?() functions.
#   3. Check the number of arguments (ARGC >= The count of '[' in parlist)
#   4. Check the value of argument whether it is in list file
#   5. Execute opt-?() functions.
# Parameter List format:
#   option is automatically printed as "(-x,-y..)"
#   option with parameter => -x=par
#   mandatory parameters => enclosed by "[]"
#   file name replaceable with stdin => enclosed by "<>"
#   optional parameters => enclosed by "()"
# List file format: (csv)
#   parameter,desctiption
_usage(){ # Show usage
    local reqp=$1;shift
    _exe_xopt
    _chkopt && _chkargc "$reqp" && _chkargv "$@" && return 0
    echo -e "Usage: $C3${0##*/}$C0 $(_optlist|_list_line)$reqp" 1>&2
    [ -t 0 ] || _list_cols 1>&2
    exit 2
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
