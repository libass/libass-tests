#!/bin/sh

usage() {
    echo "run.sh <compare> <profile>" 1>&2
}

if [ "$#" -ne 2 ] ; then
    usage
    exit 1
fi

if [ ! -e "$1" ] || [ ! -e "$2" ] ; then
    echo "Executeable of compare or profile does not exist!" 1>&2
    exit 1
fi

set -e
cmpExe="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
prfExe="$(cd "$(dirname "$2")"; pwd)/$(basename "$2")"
set +e


cd "$(dirname "$0")"

echo "Crash-Tests"
echo "==========="
(cd crash; ./run-all.sh "$prfExe")

if [ "$?" -ne 0 ] ; then
    echo "Crash tests failed!" 1>&2
    exit 2
else
    echo "Passed crash tests."
    echo ""
fi


echo "Regression-Tests"
echo "================"

(cd regression; ./run-all.sh "$cmpExe")

if [ "$?" -ne 0 ] ; then
    echo "Regression tests failed!" 1>&2
    exit 3
else
    echo "Passed regression tests."
    echo ""
fi

echo "All is well." 1>&2
