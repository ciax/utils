#!/bin/bash
# Required packages: libxml2-utils closure-linter
# Required scripts: func.getpar
# Description: Overwrite if these are different.
#alias fm
safe_ow(){
    if [ -s $1 ] ; then
        _overwrite $2 < $1 && _msg "Update $2"
    fi
}
. func.getpar
_usage "[file] ..."
_temp temp
for file ;do
    ext=${file#*.}
    case $ext in
        xml)
            echo "XML Processing"
            xmllint --format $file > $temp
            safe_ow $temp $file
            ;;
        html)
            echo "HTML Processing"
            xmllint --html $file > $temp
            safe_ow $temp $file
            ;;
        js)
            echo "JS Processing"
            fixjsstyle $file
            ;;
        *);;
    esac
done
