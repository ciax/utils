#!/bin/sh
case `uname` in
    SunOS)
        OSS_SYSTEM=/app/OSS/GLOBAL_DEBUG/OSS_SYSTEM
        OSSL_LOG=/app/oss_data/OBS_NFS
        OSS_CMDPATH=/app/LOAD/DEBUG
        OSS_OBS_HOST=cxws
        PATH=$OSS_SYSTEM:$OSS_CMDPATH:$PATH
        ;;
    Linux)
        PYTHONPATH=~/gen2/share/Git/python
        [ -d "$PYTHONPATH" ] || { echo "NO OSS files"; exit; }
        ;;
esac
port=${1:-9999}
srv="socat tcp-l:$port,reuseaddr,fork EXEC:'/bin/sh'"
ps -ef|grep -q "$srv" && exit
echo "Start OSS Redirector at [$port]"
$srv &