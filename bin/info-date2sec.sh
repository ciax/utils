#!/bin/bash
# Required packages: date
# Description: Convert Date to Unix Second
# Usage: info-date2sec [month] (day)
#alias d2s
mon=${1:-$(date +%m)}
day=${2:-$(date +%d)}
case $(uname) in
    Linux)
        date -d "$mon/$day" +%s
    ;;
    Darwin) # Mac OSX
        date -j $(printf "%02d%02d0000" $mon $day) +%s
        ;;
    *)
        exit;;
esac
