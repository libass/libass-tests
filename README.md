## Some Regression Tests for Libass

Here are some regression tests for (libass)[https://github.com/libass/libass]
requiring (un)merged patches.
If patches get merged the test may also be moved to the regular libass
regression test infrastructure. Until then here's a stopgap solution:

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

### How to add tests (stopgap)
Each non-dot folder except `fonts` contains one set of tests.

If a if a file named `scale` is present in a test directory its content will be 
catted and used as the scale value for the test.  
Otherwise the default scale value will be used.

### Directory-Hierachy (stopgap)
Each non-dot folder contains a set of tests.
Subdirectories of test directories will be ignored.

All Fonts must be located in `.fonts` and symlinked with a relative path in the 
test-directories to avoid duplications.
