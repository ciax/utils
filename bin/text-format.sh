#!/bin/bash
# Required packages: libxml2-utils
# Required scripts: func.getpar
# Description: Overwrite if these are different.
#alias fmt
. func.getpar
_usage "[file] ..."
_temp temp
for file ;do
    ext=${file#*.}
    case $ext in
        html|xml)
            echo "Processing"
            xmllint --format $file > $temp
            _overwrite $file < $temp && _msg "Update $file"
            ;;
        *);;
    esac
done
