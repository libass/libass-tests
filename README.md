# Libass Tests

This contains some autated tests for libass.

First there are “crash-tests”, which only require libass to not crash or exit 
with an error while processing the input.
  
Second, there are “regression-tests”, designed to detect inadvertent regressions 
in libass rendering (or other inadvertent rendering changes).
Libass' `compare` utility is used to check if the rendering matches the expected 
results.

The shell scripts assume the presence of the non-POSIX 
`xargs -0` and `find -print0` extensions. Otherwise purely POSIX.
