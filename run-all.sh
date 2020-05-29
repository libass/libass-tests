#!/bin/sh

# Janky stopgap script to run several tests

PARALLEL="1"

usage() {
	echo 'run-all.sh [<dir of compare executable>] [<root dir of tests>]'
}

getDir()
(
	dirr="${1:-./}"
	dirr="$(echo -n "$dirr" | sed -e 's/\/$//')""/"
	echo "$dirr"
)

if [ "$#" -gt 2 ] ; then
	echo "Too many arguments !"
	usage()
	exit 1
fi

cmpDir="$(getDir $1)"
tstDir="$(getDir $2)"

# The actual tests
find "$tstDir" -maxdepth 1 -type d -not -name ".*" -print0 | xargs -0 -P "$PARALLEL" -n 1 "$cmpDir"compare
es="$?"

if [ "$es" -eq 127 ] ; then
	echo "There was no compare executable at $cmpDir !"
elif [ "$es" -eq 126 ] ; then
	echo "'compare' at $cmpDir is not executable !"
elif [ "$es" -eq 125 ] ; then
	echo "One or more tests were interrupted !"
elif [ "$es" -eq 0 ] ; then
	echo "All tests passed !"
else
	echo "One or more tests failed. See messages above !"
fi

exit "$es"

