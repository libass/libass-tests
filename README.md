# Libass Tests

Testing is best done with a libass build having ASAN and UBSAN enabled.
E.g.:
```sh
make clean \
 && make CC="gcc -fsanitize=address -fsanitize=undefined -fsanitize=float-cast-overflow -fno-sanitize-recover=all" -j 6
```
*(After the currently pending division-by-zero-bugs are fixed
`-fsanitize=float-divide-by-zero` should be added as well)*

There are two types of tests:

## Regression Tests
Those tests compare the rasterized output with a known good sample,
reporting deviations. Does not use system font providers.

Reference samples are produced on amd64 using SSE-math
(`float`: 32bit, `double`: 64bit), if run on a platform
with different floating point precision, some test will
show slight deviations, but should notrmally still pass
with `GOOD` anyway. If the floating point precision matches
all tests should pass as `SAME` without any deviations.

## Crash Tests
Intended to feed libass various scripts with all kind of different inputs who
might not (yet) have a stable and known-good output to compare against.
As long as libass manages to handle this input without erroring out or worse
crashing, the test is passed.

Those tests should try to cover many codepaths and unusual combinations, that
are easily forgotten to take into account, although they don't need to cover
insane inputs as fuzzing might produce.

Does use the system font provider.

## Run all tests
```sh
PARALLEL=1 ./run.sh <libass-dir>/compare/compare <libass-dir>/profile/profile
```

How many tests are run simultaneously is controlled via the `PARALLEL`
environment variable; if not set it will defaul to `1`(sequential).
Running test in parallel decreases test time, but mangles the output. If any
tests fails, rerunning in sequential mode is advised to get a proper log for
what's failing.

## Requirements
The shell scripts assume the presence of the non-POSIX
`xargs -0` and `find -print0 -maxdepth -mindepth` extensions.
Otherwise pure POSIX.

## Todo
 - Crash test would ideally use a high coverage corpus,
   instead of the few randomly thrown together files used now.
