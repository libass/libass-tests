#!/bin/sh

PARALLEL="${PARALLEL:-1}"

# Interpret xarg return codes
xargsRetCode2Msg() {
	if [ "$#" -ne 1 ] ; then
		echo "xargsRetCode2Msg must be called with exactly one argument !" 1>&2
	fi

	if [ "$es" -eq 127 -o "$es" -eq 126 ] ; then
		echo "Couldn't find executable shell. Something is  v e r y  wrong."
	elif [ "$es" -eq 125 ] ; then
		echo "One or more tests were interrupted !"
	elif [ "$es" -eq 0 ] ; then
		echo "All tests passed !"
	else
		echo "One or more tests failed. See messages above !"
	fi
}

#Get a directory path with guaranteed trailing slash
getDir()
(
	dirr="${1:-./}"
	dirr="$(echo -n "$dirr" | sed -e 's/\/$//')""/"
	echo "$dirr"
)

# Test if file is executable (and exists)
# Exit with error 1 otherwise
assertExe() {
	if [ ! -x "$1" ] ; then
		echo "There's no '$(basename $1)' in the given location or it is not executable !"
		echo "   ($(dirname $1))"
		exit 1
	fi
}

# Test if run-all variant is used correctly, exit with error 1 otherwise
# Args: <utility name> <all other args, passed by "$@"> ...
assertUsage() {
	if [ "$#" -gt 3 ] ; then
		echo "Too many arguments !"
		echo 'run-all.sh [<dir of $1 executable>] [<root dir of tests>]'
		exit 1
	fi
}
