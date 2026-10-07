# trig.awk
# Written by Peter Miller 6-10-2026
# Provides tan(x), asin(x) and acos(x) functions for awk
# These are very accurate (approximately the same accuracy as the functions in the UCRT), but are not exact
# 
#
# Copyright (c) 2026 Peter Miller
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function tan(x) # x is in radians . Return value is 0 to +/- infinity
{return sin(x)/cos(x)
}

function asin(x) # returns arc sine of x in radians, x must be in the range -1 to 1. Return value is -Pi/2 to Pi/2 
{ # asin(x) = atan2 (x, sqrt ((1.0 + x) * (1.0 - x)))
 #  using (1+x)*(1-x) is more accurate than 1-x*x.
 return  atan2 (x, sqrt ((1.0 + x) * (1.0 - x)))
} 

function acos(x) # returns arc cosine of x in radians, x must be in the range -1 to 1. Return value is 0 to Pi
{ # acos(x) = atan2 (sqrt ((1.0 + x) * (1.0 - x)), x)
  # (1+x)*(1-x) is more accurate than 1-x*x.
  return atan2(sqrt((1.0 + x) * (1.0 - x)),x);
}