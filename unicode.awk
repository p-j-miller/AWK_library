# unicode.awk
# written by Peter Miller 14/8/2024
# ord(), chr() functions losely based on the Public Domain ord() by Arnold Robbin
# This has only been tested in wmawk2 compiled with unicode i/o
# see https://dev.to/rdentato/utf-8-strings-in-c-1-3-42a4 for an explanation
#
# functions provided:
#  ord(str) returns the numerical value of the 1st character of str. returns -1 if no bytes in str
#  chr(c) returns the 8 bit byte as a 1 element string matching the number c
#  u8length(ustr) returns the number of utf8 characters in string ustr - assumes the encoding is valid utf8. This is the utf8 version of the standard awk function length() - but it only works on arguments that are utf8 encoded strings.
#  lenu8chr(ustr) returns the number of bytes in the 1st utf8 character in string ustr - assumes the encoding is valid utf8
#  u8substr(ustr, ustart [, ulength]) returns the utf8 string starting at the ustart utf8 character (numbered from 1) of ustr. If ulength is supplied this is the length (in utf8 characters) of the returned string, othewise the complete suffix is returned.  
#									  This is the utf8 version of the built in awk function substr().
#
# a single global array _ord_[] is created (automatically, when its first needed)

 
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

function ord(str,    i)
{   if( !(" " in _ord_) )
		{# need to initialise lookup array (just once), this avoids the need for a BEGIN block and a seperate function to do this
		 # print "ord(): initialising _ord_[]"
		 for (i = 0; i <= 255; i++) 
			_ord_[sprintf("%c", i)] = i
		 _ord_[""] = -1 # avoid having to make this a special case in the return below
		}
    return _ord_[substr(str, 1, 1)] # we don't need to check if there are any characters in str as that's already handled by _ord_[""]= -1
}

function chr(c)
{
    # force c to be numeric by adding 0
    return sprintf("%c", c + 0)
}

function u8length(ustr,    i,j,len)
{# returns the number of utf8 characters in string ustr - assumes the encoding is valid utf8
 # This is the utf8 version of the standard awk function length() - but it only works on arguments that are utf8 encoded strings.
 len=0
 if( !(" " in _ord_) ) ord("") # initialise _ord_[] if required
 for(i=1;i<=length(ustr);++i)
	{j=_ord_[substr(ustr,i,1)]
	 if(j>=192 || j<128) ++len # >= C0 is the leading byte of a multibyte sequence, 0-7f are 1 byte chars
	}
 return len
}

function lenu8chr(ustr,      i,j) 
{# returns the number of bytes in the 1st utf8 character in string ustr - assumes the encoding is valid utf8. returns 0 if ustr=""
 if(length(ustr)<1) return 0
 if(ord(ustr)<128) return 1 # simple 1 byte character - we use ord() here to ensure _ord_[] is initialised correctly
 # if we get here is a multibyte character, look for its end
 for(i=2;i<=length(ustr);++i)
	{j=_ord_[substr(ustr,i,1)]
	 if(j>=192 || j<128) return i-1 # >= C0 is the leading byte of a multibyte sequence, 0-7f are 1 byte chars so both indicate the start of the next character
	}
 return i-1
}

function u8substr(ustr, ustart , ulength      , i,j,cnt,l)
{# this is the utf8 version of the standard awk function substr()
 # ustart and ulength are in utf8 character counts
 # if ulength is omitted or <1 then this function returns the whole suffix of ustr from the ustart utf8'th character
 # if ustart<=1 the the returned string starts with its first character (strictly the 1st character is given by ustart=1).
 i=1; cnt=1
 while(i<=length(s) && cnt<ustart)
	{l=lenu8chr(substr(ustr,i)) # length of next character
	 i+=l
	 ++cnt
	} 
 # i is now the index corresponding to start
 if(ulength+0<1) return substr(ustr,i) # whole suffix
 # now find index corresponding to start+length (j)
 j=i; cnt=1
 while(j<=length(s) && cnt<=ulength)
	{l=lenu8chr(substr(ustr,j)) # length of next character
	 j+=l
	 ++cnt
	} 
 return substr(ustr,i,j-i)
}
