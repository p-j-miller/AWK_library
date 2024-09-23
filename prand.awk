# prand.awk
# Written by Peter Miller 26-8-2024
# Portable pseudo random number generator that should give an identical sequence of numbers on any awk implementation.
#
# Copyright (c) 2024 Peter Miller
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

function prand() # Based on the portable random number generator from Numerical recipes 1st edition.  
		# Its advantage is that it should give identical results with all awk interpreters
		# Constants from table 3 in "TABLES OF LINEAR CONGRUENTIAL GENERATORS OF DIFFERENT SIZES AND GOOD LATTICE STRUCTURE" by PIERRE L’ECUYER, Jan 1999
		# Do not use this for any cryptographic applications, but its period of 34,359,738,337 should be adaquate for many applications.
		# It was developed to generate test cases for various algorithms (like sort, median).
		# it generates a uniformly distributed random number between 0 and 1. 0 and 1 will never be generated.
		# Note Cliff random number generator is sometimes suggested for this type of application - but the author found this did not generate uniformly distributed random number between 0 and 1 
		# (it does does generate numbers between 0 and 1 but they are not uniformly distributed so for example do not give an average of 0.5 when a large number of values are generated).
		# Taking the average of a large number of values returned by prand() will give a number very close to 0.5
{if(rand_value<=0) rand_value=2147483647 # 2^31-1 is used as a seed - it could be any value >0. rand_value is a global variable, thats automatically created when required.
 rand_value=int((rand_value*185852) %34359738337 ) # rand_value*(m-1)<2^53 so will fit exactly in an ieee double 
 return rand_value/34359738337  # returns a number >0..<1   
}