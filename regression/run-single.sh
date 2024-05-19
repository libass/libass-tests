#!/bin/sh

#Defines PARALLEL, getDir, assertExe, assertUsage and xargsRetCode2Msg
. ../lib.sh

assertUsage "compare" "$@"

# Overrides the default pass level for all tests
export ART_REG_TOLERANCE="${ART_REG_TOLERANCE:-2}"

cmpExe="$1"
assertExe "$cmpExe"
testDir="$(getDir "$2")"
scale="$(cat "${testDir}scale" 2>/dev/null || echo 1)"

set +e

$ART_BINWRAP "$cmpExe" "$testDir" -s "$scale" -p "$ART_REG_TOLERANCE"

ret="$?"

if [ "$ret" -ne 0 ] ; then
    printf 'FAILURE: %s (%s)\n' "$1" "$ret"
fi

exit "$ret"
