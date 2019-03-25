#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): libxml2-utils closure-linter
# Required packages(CentOS): libxml2
# Required scripts: func.getpar bkup-stash
# Description: Overwrite if these are different.
#alias fm
safe_ow(){
    if [ -s $1 ] ; then
        if _overwrite $2 < $1 ; then
            bkup-stash $2
            _msg "Update $2"
        fi
    fi
}
. func.getpar
_usage "[file] ..."
_temp temp
for file ;do
    ext=${file#*.}
    case $ext in
        xml|xsd)
            echo "XML Processing"
            xmllint --format $file > $temp
            safe_ow $temp $file
            ;;
        html)
            echo "HTML Processing"
            xmllint --html $file > $temp
            safe_ow $temp $file
            ;;
        json)
            echo "JSON Processing"
            python -m json.tool $file > $temp
            safe_ow $temp $file
            ;;
        js)
            echo "JS Processing"
            # Overwrites by itself
            fixjsstyle $file
            ;;
        *);;
    esac
done
