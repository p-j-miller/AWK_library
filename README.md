# AWK_library
A library of useful AWK functions - in particular for use with Wmawk2, but they should work with any AWK interpreter.
They have only been tested with Wmawk2 version 2.0 and above.

More details are given as comments in each of the files.

## prand.awk
A portable random number generator that generates reasonable quality random numbers and should generate the same sequemce on all awk interpreters. Used by the test programs below to ensure the same tests are always generated.
## median.awk
Quickly calculates the numerical median of an array or part of an array. Does not change the supplied array or data (or take a copy of it).
## qsort.awk
Fast sort functions, with guaranteed O(n*log(n)) execution time and maximum stack depth of log2(n) where n is the number of elements in the array to be sorted.
Uses a variant of the introsort algorithm see "Introspective sorting and selection algorithms" by D.R.Musser,Software practice and experience, 8:983-993, 1997.
Can be used to sort reasonably large arrays (10,000,000 element arrays are used in the test program).
## strftime.awk
Converts date/time as a string to seconds past the epoch, or seconds past the epoch to a date/time string.
## unicode.awk
Provides functions to manipulate unicode (utf8) strings.
## *_test.awk
Test programs for the above files
The test programs may use specific capabilities of Wmawk2 - in particular systime(0) and systime(1) - but they are easily edited to remove these dependancies.
