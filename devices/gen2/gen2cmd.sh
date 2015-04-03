#!/bin/bash
case `uname` in
    SunOS)
        OSS_SYSTEM=/app/OSS/GLOBAL_DEBUG/OSS_SYSTEM
        OSSL_LOG=/app/oss_data/OBS_NFS
        OSS_CMDPATH=/app/LOAD/DEBUG
        OSS_OBS_HOST=cxws
        PATH=$OSS_SYSTEM:$OSS_CMDPATH:$PATH
        cmd="OSST_ciaxTSCcommand"
        ;;
    Linux)
        PYTHONPATH=~/gen2/share/Git/python
        [ -d "$PYTHONPATH" ] || { echo "NO OSS files"; exit; }
        cmd="$PYTHONPATH/Gen2/client/g2cmd.py"
        ;;
esac
TIMEOUT=10;
mkcmd(){ # (-b) [timeout] [commands]
    if [ "$1" = -b ] ; then
        shift
        TIMEOUT=180
        cmd="-b"
    fi
    args="'EXEC TSC NATIVE CMD=\"$*\"'"
    case `uname` in
        SunOS)
            cmd="$cmd $TIMEOUT $args";;
        Linux)
            cmd="$cmd $args $TIMEOUT";;
    esac
    echo $cmd >&2
}
case "$1" in
    login) mkcmd "1A1901ciax%%%%%%%%%%%%%%%% CIAX%%%%%%%%%%%% dummyunit dummyMenu dummyMessage";;
    logout) mkcmd "1A1902";;
    init)  mkcmd "1A1011";;
    tsconly) mkcmd "1A1008TSCONLY";;
    tscpri) mkcmd "1A1008TSCPRI%";;
    ron) mkcmd "904013";;
    roff) mkcmd "904014";;
    jon) mkcmd "132001ON%";;
    joff) mkcmd "132001OFF";;
    jres) mkcmd "132008";;
    rhook) mkcmd -b "132004";;
    runhk) mkcmd -b "132005";;
    rstop) mkcmd "104011";;
    ajup) mkcmd -b "932001";;
    ajdw) mkcmd -b "932002";;
    ajstop) mkcmd "932003";;
    jup) mkcmd -b "932004";;
    jdw) mkcmd -b "932005";;
    jstop) mkcmd "932006";;
    setinst) mkcmd "1320070001";;
    '')
        echo "Usage: gen2cmd (-b) [osscmd|rawcmd]"
        echo "    login,logout,init,tsconly,tscpri"
        echo "    ron,roff,jon,joff,jres"
        echo "    rhook,runhk,rstop"
        echo "    ajup,ajdw,ajstop"
        echo "    jup [n],jdw [n],jstop [n]"
        echo "    setinst [n]"
        exit;;
    *) mkcmd $*;;
esac
exelog $cmd
