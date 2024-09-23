# Algorithms from "Astronomical Formulae for Calculators" By J.Meeus, 1982
# Original awk script from https://stackoverflow.com/questions/56235818/how-to-speed-up-awk-command-in-linux
# The same algorithms are used in Numerical Recipees julday() and caldat()
# This implementation by Peter Miller 11/9/2024
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
#

function mktime_awk(datestring,    a,t) {# expects a date as a string in the format yyyy-mm-dd HH:MM:SS.s with yyyy>=1970 [ exactly the format created by strftime_awk() below]
    split(datestring,a,/[ :-]/) # a[1]=years (4 digits), a[2]=months, a[3]=day of month, a[4]=hours (24 hr clock), a[5]=minutes, a[6]=secs (secs don't have to be an integer)
    if (a[1] < 1970) return -1
    if (a[2] <= 2) { a[1]--; a[2]+=12 }
    t=int(a[1]/100); t=2-t+int(t/4)
    t=int(365.25*a[1]) + int(30.6001*(a[2]+1)) + a[3] + t - 719593
    return t*86400 + a[4]*3600 + a[5]*60 + a[6]
}

function strftime_awk(epoch, JD,yyyy,mm,dd,HH,MM,SS,A,B,C,D,E ) {# epoch is secs since 1970-01-01 00:00:00.000000 as returned by systime() or mktime_awk()
    if (epoch < 0 ) return "0000-00-00 00:00:00.000000" # return value if epoch is invalid
    JD=epoch; SS=JD%60; JD-=SS; JD/=60; MM=JD%60;
    JD-=MM; JD/=60; HH=JD%24; JD-=HH; JD/=24;
    JD+=2440588
    A=int((JD - 1867216.25)/(36524.25))
    A=JD+1+A-int(A/4)
    B=A+1524; C=int((B-122.1)/365.25); D=int(365.25*C); E=int((B-D)/30.6001)
    dd=B-D-int(30.6001*E)
    mm = E < 14 ? E-1 : E - 13
    yyyy=mm>2?C-4716:C-4715
	# at this point yyyy=years. mm=months, dd=day of month, HH=hours (24 hour), MM=minutes, SS=seconds (SS may not be an integer).
    return sprintf("%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%09.6f",yyyy,mm,dd,HH,MM,SS)
}
