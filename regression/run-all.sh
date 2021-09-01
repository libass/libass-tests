#!/bin/sh

#Defines PARALLEL, getDir, assertExe, assertUsage and xargsRetCode2Msg
. ../lib.sh

assertUsage "compare" "$@"

cmpExe="$1"
tstDir="$(getDir $2)"

assertExe "$cmpExe"

# The actual tests
find "$tstDir" -maxdepth 1 -mindepth 1 -type d ! -name ".*" -print0 \
 | xargs -0 -P "$PARALLEL" -I '{}' \
    sh -c '
        if [ ! -d "$1" ] ; then
            exit 1
        fi
        echo "[TEST]: $1"
        if [ -f "$1"/scale ] ; then
            "$2" "$1" -s "$(cat "$1"/scale)"
        else
            "$2" "$1"
        fi
        ret="$?"
        echo ""
        exit "$ret"
    ' _ "{}" "$cmpExe"
es="$?"

xargsRetCode2Msg "$es"

exit "$es"
