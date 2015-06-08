#!/bin/bash
# Description: Convert Date (Beggining the daty) to Unix Second
# Usage: info-date2sec [(month/)day|(-day)]
#alias d2s
conv_duration(){ # print 20XX-XX-XX startsec endsec
    local date=$1
    case "$1" in
        ''|0) date=$(date +%m/%d);;
        -*) date=$(date +%m/%d);dif="$1";;
        */*) date=$1;;
        *) date="$(date +%m)/$1";;
    esac
    case $(uname) in
        Linux) setopt="-d \"$date${dif:+ $1day}\"";;
        Darwin) setopt="-j $(printf %02d%02d0000 ${date//// })${dif:+ -v$1d}";;
    esac
    echo date=$(eval "date $setopt +%F") # 20XX-XX-XX
    echo sec=$(eval "date $setopt +%s")
}
[ "$1" ]||{ echo "Usage: info-date2sec [(month/)day|(-day)]"; exit; }
conv_duration $*
