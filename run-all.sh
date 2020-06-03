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

if [ ! -x "$cmpDir"compare ] ; then
	echo "There's no 'compare' in the given location or it is not executable !"
	echo "   ($cmpDir)"
	exit 1
fi

# The actual tests
find "$tstDir" -maxdepth 1 -type d -not -name ".*" -print0 \
 | xargs -0 -P "$PARALLEL" -n 1 -I {} \
	sh -c '
		if [ ! -d "$1" ] ; then
			exit 1
		fi
		echo "[TEST]: $1"
		if [ -f "$1"/scale ] ; then
			"$2"compare "$1" -s "$(cat "$1"/scale)"
		else
			"$2"compare "$1"
		fi
		echo ""
	' _ "{}" "$cmpDir"
es="$?"

# Handling return value
if [ "$es" -eq 127 -o "$es" -eq 126 ] ; then
	echo "Couldn't find executable shell. Something is  v e r y  wrong."
elif [ "$es" -eq 125 ] ; then
	echo "One or more tests were interrupted !"
elif [ "$es" -eq 0 ] ; then
	echo "All tests passed !"
else
	echo "One or more tests failed. See messages above !"
fi

exit "$es"
