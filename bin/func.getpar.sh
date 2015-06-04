#!/bin/bash
# Option parse module
# Usage:
#  souce $0 at head of file,
#  set opt-?() or xopt-?() functions,
#  _usage()
#  _exe_opt()
. func.temp
_list_cols(){ # Show folded list from StdIn
    local size=0 tmplist item line
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
    local line arg
    egrep '^ +[a-z]+\)' $0 |\
    while read line;do
        arg="${line%%)*}"
        echo -n "${arg#* }"
        [[ "$line" =~ '#' ]] && echo ",${line#*#}" || echo
    done
}
_optlist(){ # List of options with opt-?() functions
    local line fnc desc
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
    local file="$1" i=0 exp
    for exp in ${ARGV[*]} ;do
        cut -d, -f1 $file| grep -q "^$exp$" || {
            _alert "Invalid argument ($exp)"
            return 1
        }
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
    local reqp=$1 arglist;shift
    if [ ! -t 0 ] ; then
        _temp arglist
        cat > $arglist
    fi
    _exe_xopt
    _chkopt && _chkargc "$reqp" &&\
        if [ "$arglist" ]; then
            _chkargv "$arglist" && return 0
        else
            return 0
        fi
    local opt=$(_optlist|_list_csv)
    opt="${opt:+ ($opt)}"
    echo -e "Usage: $C3${0##*/}$C0$opt $reqp" 1>&2
    [ "$arglist" ] && _list_cols < $arglist 1>&2
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
