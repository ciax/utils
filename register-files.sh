#!/bin/bash
# Required: readlink
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"

chklink(){
    # if dst file exists -> dst=regular file:>fail , dst=org link:>skip
    src=$1
    [ ! -e $2 ] && return 0 # Create or Overwrite unexist link
    [ -h $2 ] || { echo "Warning: $2 was regular file"; return 1; }
    dst=`readlink $2`
    [ "$src" != "$dst" ] || return 1
    echo "Warning: link of $2 is different from $src"
}

shopt -s nullglob
bd="$HOME/bin"
dd="$HOME/db"
for i in $bd $dd; do
    [ -d "$i" ] || mkdir "$i"
done

for i in ${*:-.}; do
    [ -e "$i" ] || continue
    [ -h "$i" ] && { echo "$i is link and skip"; continue; }
    if [ -d "$i" ] ; then
        dir=`cd $i;pwd -P`
        for j in $dir/*; do
            [ -d $j ] && continue
            base=${j##*/}
            case $base in
                *~) continue;;
                *.csv|*.tsv)
                    ln=$base
                    lp="$dd/$ln"
                    chklink "$j" "$lp" || continue
                    ll="$ll$ln ";;
                *)
                    [ -x "$j" ] || continue
                    ln=${base%.*}
                    lp="$bd/$ln"
                    chklink "$j" "$lp" || continue
                    bl="$bl$ln ";;
            esac
            ln -sf "$j" "$lp"
        done
    fi
done
[ "$bl" ] && echo "[ $bl] -> $HOME/bin"
[ "$ll" ] && echo "[ $ll] -> $HOME/db"
for i in $bd/* $dd/*; do
    [ -f $i ] || { rm $i; echo "link of [${i##*/}] was removed"; }
done
