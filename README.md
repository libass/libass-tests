J# Libass Tests

A first attempt at a libass test suite.
Intented to make it easier to both discover flaws in the code of patches and
unintended side-effects/regression early before they hit master.

Testing is best done with a libass build having ASAN and UBSAN enabled.
E.g.:
```sh
make clean && make CC="gcc -fsanitize=address -fsanitize=undefined -fno-sanitize-recover" -j6
```
*(As soon as the current division-by-zero-bugs are fixed
`-fsanitize=float-divide-by-zero` should be added as well)*

There are two types of tests:

## Regression Tests
Those tests compare the rasterized output with a known-good sample, reporting
deviations.

## Crash Tests
Intended to feed libass various scripts with all kind of different inputs who
might not (yet) have a stable and known-good output to compare against.
As long as libass manages to handle this input without erroring out or worse
crashing, the test is passed.

Those tests should try to cover many codepaths and unusual combinations, that
are easily forgotten to take into account, although they don't need to cover
insane inputs as fuzzing might produce.

## Run all tests
```sh
PARALLEL=1 ./run.sh <libass-dir>/compare <libass-dir>/profile
```

How many tests are run simultaneously can be controlled with the `PARALLEL`
environment variable, if not set it will defaul to `1`(sequential).
Running test in parallel decreases test time, but mangles the output. If any
tests fails, rerunning in sequential mode is advised to get a proper view on
what's failing.

## Requirements
The shell scripts assume the presence of the non-POSIX
`xargs -0` and `find -print0` extensions. Otherwise purely POSIX.

## Todo
Currently there are not many tests and those that already are there are either
too verbose/repetitve or not broad enough.

Also crash test would profit from a dedicated test/fuzz consumer as eg
[this](https://github.com/TheOneric/libass/commits/fuzz)
added, instead of relying on profile, which processes events more often than
needed for this kind of test.

The real test-suite should use `git-lfs`, a rsync-server or something similar to
store the image samples outside of git's history, as otherwise the git repo will
soon grow too large.
