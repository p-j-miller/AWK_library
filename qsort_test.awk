# Test code for qsort.awk
# Written by Peter Miller 26-8-2024
# run as: wmawk2 -f qsort.awk -f prand.awk -f qsort_test.awk
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

function testq(arr,maxi,    i,mint,maxt,sizet) # note errs is a global variable
{# test qsort on arr with maxi elements & and a subset in the middle
 if(maxi>201)
	{# also test a segment in the middle
     mint=100
	 maxt=201
	 sizet=1+maxt-mint
	 _qsort(arr,mint,maxt)	
	 if(length(arr)!=maxi) {errs++;printf("   _qsort():Number of elements in arr changed - should be %d found %d\n",length(arr),maxi)}
	 for(i=mint+1;i<=maxt;++i) # check segment is sorted
		if(arr[i-1]>arr[i]) {errs++;printf("   _qsort():Array not properly sorted arr[%d]=%g arr[%d]=%g\n",i-1,arr[i-1],i,arr[i])}	 
	}
 # now test using whole array
 qsort(arr,maxi) # sort array 
 # check number of elements unchanged by sort
 if(length(arr)!=maxi) {errs++;printf("   qsort():Number of elements in arr changed - should be %d found %d\n",length(arr),maxi)}
 # now check result is sorted
 for(i=2;i<=maxi;++i)
	if(arr[i-1]>arr[i]) {errs++;printf("   qsort():Array not properly sorted arr[%d]=%g arr[%d]=%g\n",i-1,arr[i-1],i,arr[i])}
}

function testi(arr,maxi,    i,mint,maxt,sizet) # note errs is a global variable
{# test isort on arr with maxi elements & and a subset in the middle
 if(maxi>201)
	{# also test a segment in the middle
     mint=100
	 maxt=201
	 sizet=1+maxt-mint
	 _isort(arr,mint,maxt)	
	 if(length(arr)!=maxi) {errs++;printf("  _isort():Number of elements in arr changed - should be %d found %d\n",length(arr),maxi)}
	 for(i=mint+1;i<=maxt;++i) # check segment is sorted
		if(arr[i-1]>arr[i]) {errs++;printf("  _isort():Array not properly sorted arr[%d]=%g arr[%d]=%g\n",i-1,arr[i-1],i,arr[i])}	 
	}
 # now test using whole array
 isort(arr,maxi) # sort array 
 # check number of elements unchanged by sort
 if(length(arr)!=maxi) {errs++;printf("   isort():Number of elements in arr changed - should be %d found %d\n",length(arr),maxi)}
 # now check result is sorted
 for(i=2;i<=maxi;++i)
	if(arr[i-1]>arr[i]) {errs++;printf("   isort():Array not properly sorted arr[%d]=%g arr[%d]=%g\n",i-1,arr[i-1],i,arr[i])}
}

# Test code
BEGIN { 
 errs=0
 start_time=systime(1)
 maxi=10000000 # number of array elemnts to sort 10000000
				# 100,000 takes 1 second, with "slow" added -> 3
				# 1,000,000 takes 15 secs with "slow" added -> 235 ! (n^2)
				# 10,000,000 takes 179 secs
				# 136/12=11.3 which is only just worse than linear (presumably because filling and checking the arrays are linear and these are a significant portion of the overall time)
 printf("Testing qsort() for %d elements\n",maxi)
 print " testing random numbers 0-1"
 for(i=1;i<=maxi;++i)
	arr[i]=prand() # fill array with random positive numbers 0..1
 testq(arr,maxi)

 print " testing random numbers +/-1"	
 for(i=1;i<=maxi;++i)
	arr[i]=1-2*prand() # fill array with random positive numbers +/-1
 testq(arr,maxi)

 print " testing integer numbers 0..maxi-1"
 for(i=1;i<=maxi;++i)
	arr[i]=i-1 # fill array with integers 0..maxi-1
 testq(arr,maxi)
 # we know exact result so check that
 for(i=1;i<=maxi;++i)
	if(arr[i]!=i-1) {errs++; printf("Difference at arr[%d] expected %d found %d\n",i,i-1,arr[i])}

 print " testing integer numbers maxi-1 to 0"
 for(i=1;i<=maxi;++i)
	arr[i]=maxi-i # fill array with integers maxi-1..0
 testq(arr,maxi)
 # we know exact result so check that
 for(i=1;i<=maxi;++i)
	if(arr[i]!=i-1) {errs++; printf("Difference at arr[%d] expected %d found %d\n",i,i-1,arr[i])}
	
 print " testing integer numbers all 5"
 for(i=1;i<=maxi;++i)
	arr[i]=5 # fill array with integers 5
 testq(arr,maxi)
 # we know exact result so check that
 for(i=1;i<=maxi;++i)
	if(arr[i]!=5) {errs++; printf("Difference at arr[%d] expected %d found %d\n",i,5,arr[i])}
	
 print " testing integer numbers mainly 5, with a few other values"
 for(i=1;i<=maxi;++i)
	arr[i]=5 # fill array with integers 5
 for(i=1;i<10;++i)
	arr[int(prand()*maxi)]=i # add in a few other values at random locations
 testq(arr,maxi)

 print " testing strings of varying length"
 s=""
 j=1 # causes "reset" on 1st iteration
 for(i=1;i<=maxi;++i)
	{ 
	 if(int(i/10)==j)
		{# gradually increase the length of the string, by 3 characters at a time
		 s=s sprintf("%c%c%c",97+i%26,97+(i/26)%26,97+(i/(26*26))%26)
		}
	 else
		{# go back to length "1" (actually 3 character)
		 j=int(i/10)
		 s=sprintf("%c%c%c",97+i%26,97+(i/26)%26,97+(i/(26*26))%26)
		}
	 arr[i]=s # actually fill array
	 # printf("arr[%d]=%s\n",i,s)
	}
 testq(arr,maxi)

 print " testing 3 character strings aaa,baa,caa,..."
 for(i=0;i<maxi;++i)
	{arr[i+1]=sprintf("%c%c%c",97+i%26,97+(i/26)%26,97+(i/(26*26))%26) # fill array with aaa,baa etc a=97
	}
 testq(arr,maxi)
 
 print " testing 5 character strings aaaaa,aaaab,aaaac,..."
 for(i=0;i<maxi;++i)
	{
	 arr[i+1]=sprintf("%c%c%c%c%c",97+(i/(26*26*26*26))%26,97+(i/(26*26*26))%26,97+(i/(26*26))%26,97+(i/26)%26,97+i%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
	}
 testq(arr,maxi)
 # we know exact result (assuming maxi<11,881,376) so check that
  for(i=0;i<maxi;++i)
	{s=sprintf("%c%c%c%c%c",97+(i/(26*26*26*26))%26,97+(i/(26*26*26))%26,97+(i/(26*26))%26,97+(i/26)%26,97+i%26  )
	 if(arr[i+1]!=s) {errs++; printf("Difference at arr[%d] expected %s found %s\n",i+1,s,arr[i+1])}
	}

 print " testing 5 character strings in reverse order"
 for(i=0;i<maxi;++i)
	{
	 arr[maxi-i]=sprintf("%c%c%c%c%c",97+(i/(26*26*26*26))%26,97+(i/(26*26*26))%26,97+(i/(26*26))%26,97+(i/26)%26,97+i%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
	}
 testq(arr,maxi)
 # we know exact result (assuming maxi<11,881,376) so check that
  for(i=0;i<maxi;++i)
	{s=sprintf("%c%c%c%c%c",97+(i/(26*26*26*26))%26,97+(i/(26*26*26))%26,97+(i/(26*26))%26,97+(i/26)%26,97+i%26  )
	 if(arr[i+1]!=s) {errs++; printf("Difference at arr[%d] expected %s found %s\n",i+1,s,arr[i+1])}
	}

 print " testing character strings of length 1 to 5"
 for(i=0;i<maxi;++i)
	{if(i==0)
		arr[i+1]=sprintf("a"  )
	 else if(i==1)
		arr[i+1]=sprintf("aa"  )
	 else if(i==2)
		arr[i+1]=sprintf("aaa"  )
	 else if(i==3)
		arr[i+1]=sprintf("aaaa"  )
	 else
		{j=i-4 # so we start with "aaaaa"
	     arr[i+1]=sprintf("%c%c%c%c%c",97+(j/(26*26*26*26))%26,97+(j/(26*26*26))%26,97+(j/(26*26))%26,97+(j/26)%26,97+j%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
		}
	}
 testq(arr,maxi)
 # we know exact result (assuming maxi<11,881,376) so check that
  for(i=0;i<maxi;++i)
	{if(i==0)
		s=sprintf("a"  )
	 else if(i==1)
		s=sprintf("aa"  )
	 else if(i==2)
		s=sprintf("aaa"  )
	 else if(i==3)
		s=sprintf("aaaa"  )
	 else
		{j=i-4 # so we start with "aaaaa"
	     s=sprintf("%c%c%c%c%c",97+(j/(26*26*26*26))%26,97+(j/(26*26*26))%26,97+(j/(26*26))%26,97+(j/26)%26,97+j%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
		}
	 if(arr[i+1]!=s) {errs++; printf("Difference at arr[%d] expected %s found %s\n",i+1,s,arr[i+1])}
	}
	
 print " testing character strings of length 1 to 5 in reverse order"
 for(i=0;i<maxi;++i)
	{if(i==0)
		arr[maxi-i]=sprintf("a"  )
	 else if(i==1)
		arr[maxi-i]=sprintf("aa"  )
	 else if(i==2)
		arr[maxi-i]=sprintf("aaa"  )
	 else if(i==3)
		arr[maxi-i]=sprintf("aaaa"  )
	 else
		{j=i-4 # so we start with "aaaaa"
	     arr[maxi-i]=sprintf("%c%c%c%c%c",97+(j/(26*26*26*26))%26,97+(j/(26*26*26))%26,97+(j/(26*26))%26,97+(j/26)%26,97+j%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
		}
	}
 testq(arr,maxi)
 # we know exact result (assuming maxi<11,881,376) so check that
  for(i=0;i<maxi;++i)
	{if(i==0)
		s=sprintf("a"  )
	 else if(i==1)
		s=sprintf("aa"  )
	 else if(i==2)
		s=sprintf("aaa"  )
	 else if(i==3)
		s=sprintf("aaaa"  )
	 else
		{j=i-4 # so we start with "aaaaa"
	     s=sprintf("%c%c%c%c%c",97+(j/(26*26*26*26))%26,97+(j/(26*26*26))%26,97+(j/(26*26))%26,97+(j/26)%26,97+j%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
		}
	 if(arr[i+1]!=s) {errs++; printf("Difference at arr[%d] expected %s found %s\n",i+1,s,arr[i+1])}
	}

 print " testing character strings of length 1 or 5  - this is very slow with Introsort functionality"
 for(i=0;i<maxi;++i)
	{if(i<26)
		arr[i+1]=sprintf("%c",97+i  )
	 else
		{j=i-26 # so we start with "aaaaa"
	     arr[i+1]=sprintf("%c%c%c%c%c",97+(j/(26*26*26*26))%26,97+(j/(26*26*26))%26,97+(j/(26*26))%26,97+(j/26)%26,97+j%26  ) # fill array with aaa,baa etc a=97, 26*26*26*26*26=11,881,376 so this is the limit for maxi
		}
	}
 testq(arr,maxi)	


 print " testing random 3 character strings like aaa,zzz,caz,..."
 for(i=0;i<maxi;++i)
	{r=int(prand()*26*26*26)
	 arr[i+1]=sprintf("%c%c%c",97+r%26,97+(r/26)%26,97+(r/(26*26))%26) # fill array with aaa,baa etc a=97, 26*26*26=17576 so this is the limit for maxi
	 # print i,arr[i+1]
	}
 testq(arr,maxi)

 print " testing strings in reverse order"
 for(i=0;i<maxi;++i)
	{r=maxi-i
	 arr[i+1]=sprintf("%c%c%c",97+r%26,97+(r/26)%26,97+(r/(26*26))%26) # fill array with aaa,baa etc a=97, 26*26*26=17576 so this is the limit for maxi
	 # print i,arr[i+1]
	}
 testq(arr,maxi)
	
 if(errs==0) print "qsort() test finished OK, total execution time was",systime(1)-start_time,"seconds"
 else print "qsort() test finished with",errs,"error(s), total execution time was",systime(1)-start_time,"seconds"
 print "" # newline
 # Testing isort() 
 delete arr  # size is different (smaller!) for isort()
 errs=0
 start_time=systime(1)
 maxi=10000 # 10,000 takes 1 to 2 seconds, 30,000 takes 14 secs, 100,000 takes 151 secs , so execution time proportional to maxi^2 as expected
		   # remember for all the qsort tests at maxi=10,000,000 takes 128 secs
 printf("Testing isort() for %d elements\n",maxi)				
 print " testing random numbers 0-1"
 for(i=1;i<=maxi;++i)
	arr[i]=prand() # fill array with random positive numbers 0..1
 testi(arr,maxi)
 if(errs==0) print "isort() test finished OK, total execution time was",systime(1)-start_time,"seconds"
 else print "isort() test finished with",errs,"error(s), total execution time was",systime(1)-start_time,"seconds"
 
}

  



    
