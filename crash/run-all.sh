#!/bin/sh

#Defines PARALLEL, getDir, assertExe, assertUsage and xargsRetCode2Msg
. ../lib.sh

assertUsage "profile" "$@"

prfDir="$(getDir $1)"
tstDir="$(getDir $2)"

assertExe "$prfDir/profile"

#Active test files must not be dotfiles and end with .ass
#Also the filename must end with
#    _<start time in ms>_<end_time in ms>(_<fps>)?.ass
#    If _<fps> is missing it defaults to 25fps
find "$tstDir" -maxdepth 1 -type f -name "*.ass" ! -name ".*" -print0 \
 | xargs -0 -P "$PARALLEL" -I '{}' \
	sh -c '
		isInvalidArg() {
			if echo "$1" | grep -q -E "^[0-9]+(\.[0-9]+)?$" ; then
				return 1
			else
				return 0
			fi
		}

		#Parse file name
		rem="${1%%.ass}"
		fps="${rem##*_}"; rem="${rem%_*}"
		t_e="${rem##*_}"; rem="${rem%_*}"
		t_s="${rem##*_}"; rem="${rem%_*}"
		if isInvalidArg "$t_s" ; then
			t_s="$t_e"
			t_e="$fps"
			fps="25"
		fi
		if isInvalidArg "$t_s" || isInvalidArg "$t_e" || isInvalidArg "$fps"
		then
			echo "Invalid times or fps, ignoring  $1  ..."
			echo ""
			exit 0
		fi

		#Actual test
		echo "[CRASH-TEST]: $rem"
		printf "  From: %7dms\n  To:   %7dms\n  fps:  %7.2f\n" \
				"$t_s" "$t_e" "$fps"

		#Would be nice if profile had a -q / --quiet option
		# to not spam all styles etc, but keep fribidi version info etc
		"$2"profile "$1" "$t_s" "$fps" "$t_e" 1>/dev/null
		ret="$?"
		if [ "$ret" -eq "0" ] ; then
			echo "OK."
		else
			echo "FAILED!"
		fi
		echo ""
		exit "$ret"
	' _ "{}" "$prfDir"
es="$?"

xargsRetCode2Msg "$es"

exit "$es"
