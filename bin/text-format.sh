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
        sh)
            echo "Bash Processing"
            fmcmd=beautify_bash
            if type $fmcmd >/dev/null; then
                $fmcmd - < $file > $temp
            else
                # Comment will be deleted
                #http://d.hatena.ne.jp/n9d/20090117/1232182669
                _temp cmdtemp
                echo "function a(){">$cmdtemp
                cat $file >>$cmdtemp
                echo -e " }\n declare -f a">>$cmdtemp
                chmod +x $cmdtemp
                $cmdtemp|sed '1,2d;$d;s/....//' > $temp
            fi
            safe_ow $temp $file
        ;;
        *);;
    esac
done
