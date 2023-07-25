#!/bin/sh

#Defines PARALLEL, getDir, assertExe, assertUsage and xargsRetCode2Msg
. ../lib.sh

assertUsage "compare" "$@"

# POSIX ERE, all test sets with matching names will be skipped
export ART_REG_SKIP="${ART_REG_SKIP:-}"
# Overrides the default pass level for all tests
export ART_REG_TOLERANCE="${ART_REG_TOLERANCE:-2}"

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
        if [ -n "$ART_REG_SKIP" ] && echo "$1" | grep -qE "$ART_REG_SKIP" ; then
            printf "[SKIP]: %s\n\n" "$1"
            exit 0
        fi
        echo "[TEST]: $1"
        if [ -f "$1"/scale ] ; then
            $ART_BINWRAP "$2" "$1" -s "$(cat "$1"/scale)" -p "$ART_REG_TOLERANCE"
        else
            $ART_BINWRAP "$2" "$1" -p "$ART_REG_TOLERANCE"
        fi
        ret="$?"
        if [ "$ret" -ne 0 ] ; then
            printf "FAILURE: %s (%s)\\n\\n" "$1" "$ret"
        else
            echo ""
        fi
        exit "$ret"
    ' _ "{}" "$cmpExe"
es="$?"

xargsRetCode2Msg "$es"

exit "$es"
