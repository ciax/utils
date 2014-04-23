#!/bin/bash
# Description: dirlist that has .git
shopt -s nullglob
showdir(){
    local i
    for i in */ ;do
        [ -h ${i%/} ] && continue
        if [ -e "$i.git" ] ; then
            echo "${i%/}"
        else
            pushd $i > /dev/null
            showdir
            popd  > /dev/null
        fi
    done
}
cd
showdir
