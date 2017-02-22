#!/bin/bash
# Required packages: libxml2-utils closure-linter
# Required scripts: func.getpar
# Description: Overwrite if these are different.
#alias fm
. func.getpar
_usage "[file] ..."
_temp temp
for file ;do
    ext=${file#*.}
    case $ext in
        html|xml)
            echo "XML Processing"
            xmllint --format $file > $temp
            if [ -s $temp ] ; then
                _overwrite $file < $temp && _msg "Update $file"
            fi
            ;;
        js)
            echo "JS Processing"
            fixjsstyle $file
            ;;
        *);;
    esac
done
