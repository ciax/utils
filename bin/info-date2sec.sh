#!/bin/bash
# Description: Convert Date (Beggining the daty) to Unix Second
# Usage: info-date2sec [(month/)day|-]
#alias d2s
conv_duration(){ # print 20XX-XX-XX startsec endsec
    local date=$1
    case "$1" in
        '') date=$(date +%m/%d);;
        */*) date=$1;;
        *) date="$(date +%m)/$1";;
    esac
    case $(uname) in
        Linux) startday="-d $date";;
        Darwin) startday="-j $(printf %02d%02d0000 ${date//// })";;
    esac
    start=$(date $startday +%s)
    echo "start=$start"
    echo "end=$(( start + 86400 ))" #One Day is 86400sec
    echo "date=$(date $startday +%F)" # 20XX-XX-XX
}
[ "$1" ]||{ echo "Usage: info-date2sec [(month/)day|-]"; exit; }
[ $1 = - ] && shift
conv_duration $*
