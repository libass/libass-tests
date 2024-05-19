## Some Regression Tests for Libass

This directory contains regression test.
Regression tests check the current output via `compare` against a known good
sample reporting deviations. This way regressions and other unintended changes
can hopefully be discovered early before patches get merged.

The tests are grouped, with each group being located in a direct
child-directory of this one. The structure of these child-directories
is described further below.

### Run tests
Run all tests by passing in the path to the compare executable
and the regression-test root dir *(defaults to `.` when ommited)*.
```
./run-all.sh <path to compare executable> [<root dir of tests>]
```

Run a single test group located in `tdir` with:
```
./run-single.sh <path to compare executable> tdir
```

### Environment Variables
When using `run-all.sh` some environment variables can be used
to adjust its behaviour.

 - `ART_REG_SKIP` can be set to a POSIX Extended Regular Expression and all test
   directories with a matching name will be skipped. This is useful for e.g. the
   non-Unicode font tests, as they rely on an iconv implementation being used
   and supporting all relevant conversions.
 - `ART_REG_TOLERANCE` changes how tolerant tests are of small changes.
   It will be passed to `compare`’s pass level option and defaults to `2`.

### Directory strucutre
Each non-dot folder contains one group of active tests.
`.fonts` contains all font files.

Inside a test-dir multiple ASS and PNG files may be present
conforming to `compare`'s format requirements.

Furthermore a test dir may contain:

 - `desc` a small text file containing information about the tests
 - `scale` a single line text file, whose content will be passed to `compare` as
    its `scale` parameter. Must satisfy `compare`'s requirements.
 - Symlinks to font files for `compare` to use. Read below.

### Fonts
To get a consistent test environment, `compare` disables system font providers
and only uses font files from each test group's directory. To not duplicate all
font files, all font files are pplaced into the common `.fonts` directory with
required fonts being symlinked into the individual test group dirs.
