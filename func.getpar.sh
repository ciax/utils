#!/bin/bash
# Option parse module
# Usage:
#  souce $0 at head of file,
#  set opt-?() or xopt-?() functions,
#  _usage()
#  _exe_opt()

shopt -s nullglob
# Description: Print alert to stderr
_alert(){ echo "$C1$*$C0" 1>&2; }
# Desctiption: Abort with message
# Usage: _abort [message]
_abort(){ _alert "$*";exit 1; }

# Description: show folded list
_list_cols(){
    while read line;do
        [[ "$line" =~ , ]] && line="$C2${line/,/$C0: }"
        echo "$line"
    done|column|while read line;do echo -e "\t$line";done
}
# Description: show lined list
_list_line(){
    while read line;do
        list="${list:+$list,}$line"
    done
    echo "${list:+($list) }"
}
# Description: list of case option
_caselist(){
    while read line;do
        arg="${line%%)*}"
        echo -n "${arg#* }"
        [[ "$line" =~ '#' ]] && echo ",${line#*#}" || echo
    done < <(egrep '^ +[a-z]+\)' $0)
}
# Description: list of options with opt-?() functions
_optlist(){
    while read line;do
        fnc="${line%%(*}"
        [[ "$line" =~ '#' ]] && desc=":${line#*#}"
        echo $C2"${fnc#*opt}$C0${desc/:=/=}"
    done < <(egrep '^x?opt-' $0)
}
# Description: check options
_chkopt(){
    for i in ${OPT[*]};do
        type -t "opt${i%%=*}" &>/dev/null && continue
        _alert "Invalid option ($i)"
        return 1
    done
}
# Description: exclusive option handling
_exe_xopt(){
    for i in ${OPT[*]};do
        if type -t "xopt${i%%=*}" &>/dev/null; then
            xopt${i//=/ }
            exit
        fi
    done
}
# Description: check the argument count
_chkargc(){
    local reqp="$1"
    local reqc="$(IFS=[;set - $reqp;echo $(($#-1)))"
    [[ "$reqp" =~ '<' ]] && [ -t 0 ] && reqc=$(($reqc+1))
    [ "$ARGC" -ge "$reqc" ] || { _alert "Short Argument"; return 1; }
}
# Description: check the argument value
_chkargv(){
    local i=0
    for file;do
        grep -q "${ARGV[$i]}" "$file" || {
            _alert "Invalid argument (${ARGV[$i]})"
            return 1
        }
        i=$(($i+1))
    done
}

# Usage: _exe_opt
# Description: option handling, don't forget to execute after _usage
_exe_opt(){
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
_usage(){
    # Show usage
    local reqp=$1;shift
    _exe_xopt
    _chkopt && _chkargc "$reqp" && _chkargv "$@" && return 0
    echo -e "Usage: $C3${0##*/}$C0 $(_optlist|_list_line)$reqp" 1>&2
    [ "$1" ] && _list_cols < "$1" 1>&2
    exit 2
}

# Option Parser
declare -a ARGV
declare -a OPT
for i;do
    case "$i" in
        -*) OPT=("${OPT[@]}" "$i");;
        *) ARGV=("${ARGV[@]}" "$i");;
    esac
    shift
done
ARGC=${#ARGV[@]}
set - "${ARGV[@]}"
