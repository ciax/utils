#!/bin/bash
shopt -s nullglob
# Description: Print alert to stderr
_alert(){ echo "$C1$*$C0" >/dev/stderr; }
# Desctiption: Abort with message
# Usage: _abort [message]
_abort(){ _alert "$*";exit 1; }

# Description: show folded list
_list_cols(){
    while read line;do
        [[ "$line" =~ , ]] && line="  $C2${line/,/$C0: }"
        echo "  $line"
    done|column
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
    done < <(grep '^opt-' $0)
}
# Description: check options
_chkopt(){
    for i in ${OPT[*]};do
        type -t "opt${i%%=*}" &>/dev/null && continue
        echo $C1"Invalid option ($i)"$C0
        return 1
    done
}
# Description: option handling
_exeopt(){
    for i in ${OPT[*]};do
        set - ${i//=/ }
        if type -t opt$1 &>/dev/null;then
            opt$*
        else
            echo $C1"Invalid option ($i)"$C0
            return 1
        fi
    done
}
# Description: check the argument count
_chkargc(){
    local reqp="$1"
    local reqc="$(IFS=[;set - $reqp;echo $(($#-1)))"
    [[ "$reqp" =~ '<' ]] && [ -t 0 ] && reqc=$(($reqc+1))
    [ "$ARGC" -ge "$reqc" ] || { echo $C1"Short Argument"$C0; return 1; }
}
# Description: check the argument value
_chkargv(){
    local i=0
    for file;do
        grep -q "${ARGV[$i]}" "$file" || {
            echo $C1"Invalid argument (${ARGV[$i]})"$C0
            return 1
        }
        i=$(($i+1))
    done
}
# Desctiption: Print usage
#   1. Check the single options. opt-?() function should be provided.
#   2. Check the number of arguments (ARGC >= The count of '[' in parlist)
#   3. Check the value of argument whether it is in list file
# ParList format:
#   option is automatically printed as "(-x,-y..)"
#   option with parameter => -x=par
#   mandatory parameters => enclosed by "[]"
#   file name replaceable with stdin => enclosed by "<>"
#   optional parameters => enclosed by "()"
# List file format: (csv)
#   parameter,desctiption
# Usage: _usage [parlist] (list files)
_usage(){
    # Show usage
    local reqp=$1;shift
    _chkopt && _chkargc "$reqp" && _chkargv "$@" && _exeopt && return 0
    echo "Usage: $C3${0##*/}$C0 $(_optlist|_list_line)$reqp" > /dev/stderr
    [ "$1" ] && _list_cols < "$1" > /dev/stderr
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
done
set - "${ARGV[@]}";ARGC=$#
