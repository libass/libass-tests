#!/bin/sh

#Defines PARALLEL, getDir, assertExe, assertUsage and xargsRetCode2Msg
. ../lib.sh

assertUsage "fuzz" "$@"

fzzExe="$1"
tstDir="$(getDir $2)"

assertExe "$fzzExe"

#Active test files must not be dotfiles and end with .ass
find "$tstDir" -maxdepth 1 -type f -name "*.ass" ! -name ".*" -print0 \
 | xargs -0 -P "$PARALLEL" -I '{}' \
    sh -c '
        echo "[CRASH-TEST]: $1"

        $ART_BINWRAP "$2" -q "$1"
        ret="$?"
        if [ "$ret" -eq "0" ] ; then
            echo "OK."
        else
            echo "FAILED!"
        fi
        echo ""
        exit "$ret"
    ' _ "{}" "$fzzExe"
es="$?"

xargsRetCode2Msg "$es"

exit "$es"
