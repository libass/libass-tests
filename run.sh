#!/bin/sh

usage() {
	echo "run.sh <compare dir> <profile dir>" 1>&2
}

cd "$(dirname "$0")"

if [ "$#" -ne 2 ] ; then
	usage
	exit 1
fi

if [ ! -d "$1"  -o  ! -d "$2" ] ; then
	echo "Compare or Profile directory does not exist !" 1>&2
	exit 1
fi

cmpDir="$(cd "$1"; pwd -P)"
prfDir="$(cd "$2"; pwd -P)"


echo "Crash-Tests"
echo "==========="
(cd crash; ./run-all.sh "$prfDir")

if [ "$?" -ne 0 ] ; then
	echo "Crash tests failed !" 1>&2
	exit 2
else
	echo "Passed crash tests."
	echo ""
fi


echo "Regression-Tests"
echo "================"

(cd regression; ./run-all.sh "$cmpDir")

if [ "$?" -ne 0 ] ; then
	echo "Regression tests failed !" 1>&2
	exit 3
else
	echo "Passed regression tests."
	echo ""
fi

echo "All is well." 1>&2
