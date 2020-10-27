J## Some Regression Tests for Libass

This directory contains regression test.
Regression tests render the output via `compare` and report deviation from a
known good output. This way regressions and other unintended side-effects can
hopefully be discovered early before patches get merged.

Tests are grouped into direct child directory of the current directory.
More information regaridng the test directory-structure can be found below.

### Run test
Run all tests with
```
 ./run-all.sh [<dir of compare executable>] [<root dir of tests>]
```

Run a single test in `tdir` with:
```
 if [ -f tdir/scale ] ; then
    compare tdir -s "$(cat tdir/scale)"
 else
    compare tdir
 fi
```

### Directory strucutre
Each non-dot folder contains one group of active tests.
`.fonts` contains all font files.

Inside a test-dir Multiple ass-files and png-files may be present according to
`compare`'s format requirements.

Furthermore a test dir may contain:

 - `desc` a small text file containing information about the tests
 - `scale` a single line text file, whose content will be passed to `compare` as
    its `scale` parameter. Must satisfy `compare`'s requirements.
 - Symlinks to font files for `compare` to use. Read below.

### Fonts
To take the system font wildcard out of the equation, `compare` disables system
font provider and only uses font files from each tests directory. To avoid
unnecessary duplicates all font files are inside the `regression/.font` dir;
required fonts are symlinked into the test dir.
