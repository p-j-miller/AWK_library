# This file contains 2 sort routines:
# isort(Array, number_of_elements) : an insertion sort
# qsort(Array, number_of_elements) : a recursive quicksort - max stack depth is log2(n) where n is number_of_elements
# in both cases array elements must be at indices 1,2,3,...,number_of_elements
# This is version 1.1: Peter Miller 18-8-2024
#
# Uses standard awk comparisons to determine the order so to guarantee sorting as strings concatenate the null string to each entry in the array before calling isort or qsort
# or to sort as numbers add 0 to each element of the array.
# isort is good for relatively small arrays (up to 10,000 elemnts but for more than ~ 100 elements qsort will be faster)
# qsort is good for large or small arrays - you are limited by RAM, but arrays of 10 million elements can easily be sorted.
# Note qsort has added Introsort functionality to guarantee O(n*log(n)) execution speed.   See "Introspective sorting and selection algorithms" by D.R.Musser,Software practice and experience, 8:983-993, 1997.

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

function middle(x,y,z)  #return middle (median) of 3 variables
{
  if ( x <= y )  
  { if ( z >= y )  return y
    if ( z <  x )  return x
    return z
  }

  if ( z >= x )  return x
  if ( z <  y )  return y
  return z
}

function  _isort(A, left, right,     i, j, hold)
{ # internal function: insertion sort from A[left] to A[right]  - suitable for moderate values of n (say 100) - but qsort will automatically use isort() if thats faster so there is normally no need to call isort directly
  for( i = left+1 ; i <= right ; i++)
   {
	if(A[i-1] > (hold = A[ j = i ])) # Note i-1 >=1 so don't need to check for that here
		{
		 j-- ; A[j+1] = A[j] # above if test duplicates 1st loop of while loop below, so don't need to repeat that check can just adjust j
		 while ( j >left && A[j-1] > hold )
			{
			 j-- ; A[j+1] = A[j] 
			}
		 A[j] = hold # we know j!=i if we get here due to if statement at start
		}
   }
}

function  isort(A , n,    i, j, hold)
{ # insertion sort - suitable for moderate values of n (say 100) - but qsort will automatically use isort() if thats faster so there is normally no need to call isort directly
 _isort(A,1,n)
}


# recursive quicksort internal function
function  _qsort(A, left, right    ,i , j, pivot, hold)
{
 while(right>left)
	 {# if only a small segment - use an insertion sort as that will be faster than using a full quicksort
	  # its faster doing this in small bits as we go alone than calling isort() at the end
	  # lastest version for maxi=10,000,000: 5 takes 129 secs, 10 takes 129 secs, 15 =>128 secs, 20 takes 129 secs, 30 takes  131 secs
	  if(right-left<=15) 
		{_isort(A,left,right)
		 return
		}
	  # initially try an insertion sort - give up if too many changes and use quicksort, use pivot to count changes to avoid another local variable
	   pivot=1 # max allowed changes (1 means use quicksort unless already sorted, 0 means skip the test completely)
			   # 0=>138 secs, 1=>128 secs, 2=>131 secs, 3=>139 secs
	   if(pivot>0) 
		  {for( i = left+1 ; i <= right ; i++)
			  {
				if(A[i-1] > (hold = A[ j = i ])) # Note i-1 >=left so don't need to check for that here
					{if(--pivot<=0) break # too many changes. 
					 j-- ; A[j+1] = A[j] # above if test duplicates 1st loop of while loop below, so don't need to repeat that check can just adjust j
					 while ( j >left && A[j-1] > hold )
						{
						 j-- ; A[j+1] = A[j] 
						}
					 A[j] = hold # we know j!=i if we get here due to if statement at start
					}
			  }
		   if(pivot>0) return # insertion sort worked, all done !	 
		  }
	 
	  # start of main quicksort code 
	  pivot = middle(A[left], A[int((left+right)/2)], A[right])

	  i = left
	  j = right

	  while ( i <= j )
	   {
		while ( A[i] < pivot )  i++ 
		while ( A[j] > pivot )  j--

		if ( i <= j )
		 {hold = A[i]
		  A[i++] = A[j]
		  A[j--] = hold
		 }
	   }
	  
	  # check for values equal to the pivot
	  while (i<=right && A[i]==pivot) ++i
	  while (j>=left && A[j]==pivot) --j
	  
	  # recursive call for smallest to limit stack depth, iterate for largest block
	  if((j - left)<(right - i))
		{# j-left is smaller 
		 if((j - left)<0.1*(right - i))
			{# partitions very unequal - use heapsort on largest partition to keep n*log(n) performance)
			 _hsort(A,i,right)
			 right=j # left unchanged
			}
		 else
			{# j-left is smaller - recurse on that one
			 _qsort(A,left,j)
			 left=i # right unchanged
			}
		}
	  else
		{# right-i is smaller 
		 if((right - i)<0.1*(j - left))
				{# partitions very unequal - use heapsort on largest partition to keep n*log(n) performance)
				 _hsort(A,left,j)
				 left=i # right unchanged
				}
		  else
				{# right-i is smaller - recurse on that one
				 _qsort(A,i,right)
				 right=j # left unchanged
				}
		}
	 }
}

# user version of qsort() 
function qsort(A, number_of_elements) # sorts array A with number_of_elements elements at indices 1,2,3,...,number_of_elements
{			 
 _qsort(arr,1,number_of_elements) # recursive quicksort 
}
 
# this version is a heapsort which has guaranteed n*log2(n) execution time  - but in general its slower than quicksort - note qsort() above uses a heapsort to guarantee n*log2(n) execution time as well.
function hsort(ra,n,      i,ir,j,L,raa)
{
 if (n < 2) return;
 # initially try an insertion sort - give up if too many changes and use heapsort, use L to count changes to avoid another local variable
 L=2 # max allowed changes (1 means use quicksort unless already sorted, 0 means skip the test completely)
	   # 0=>50 secs, 1=>41 secs, 2=>41 secs, 3=>41 secs, 4=>41, 5=>41
 if(L>0) 
  {for( i = 2 ; i <= n ; i++)
	  {
		if(ra[i-1] > (raa = ra[ j = i ])) # Note i-1 >=1 so don't need to check for that here
			{if(--L<=0) break # too many changes. 
			 j-- ; ra[j+1] = ra[j] # above if test duplicates 1st loop of while loop below, so don't need to repeat that check can just adjust j
			 while ( j >1 && ra[j-1] > raa )
				{
				 j-- ; ra[j+1] = ra[j] 
				}
			 ra[j] = raa # we know j!=i if we get here due to if statement at start
			}
	  }
   if(L>0) return # insertion sort worked, all done !	 
  } 
 L=int(n/2)+1;
 ir=n;
 for (;;) 
	{
	 if (L > 1) 
		{
		 rra=ra[--L];
		} 
	 else 
		{
		 rra=ra[ir];
		 ra[ir]=ra[1];
		 if (--ir == 1) 
			{
			 ra[1]=rra;
			 break;
			}
		}
	 i=L;
	 j=L+L;
	 while (j <= ir) 
		{
		 if (j < ir && ra[j] < ra[j+1]) j++;
		 if (rra < ra[j]) 
			{
			 ra[i]=ra[j];
			 i=j;
			 j =j+j;
			} 
		 else break;
		}
	 ra[i]=rra;
	}
}
  
# this version is a heapsort which has guaranteed n*log2(n) execution time  sorts array from left to right
# uses as a "backup" in qsort() above when quicksort is not working fast enough.
function _hsort(ra,left, right,      n,i,ir,j,L,raa)
{n=right-left+1
 if (n < 2) return;
 # initially try an insertion sort - give up if too many changes and use heapsort, use L to count changes to avoid another local variable
 L=0 # max allowed changes (1 means use quicksort unless already sorted, 0 means skip the test completely)
	   # when used as a standalone sort 0=>50 secs, 1=>41 secs, 2=>41 secs, 3=>41 secs, 4=>41, 5=>41
	   # when used from qsort() its very unlikley it will be called with simple things to sort, so L=0 is probably best !
 if(L>0) 
  {for( i = left+1 ; i <= right ; i++)
	  {
		if(ra[i-1] > (raa = ra[ j = i ])) # Note i-1 >=left so don't need to check for that here
			{if(--L<=0) break # too many changes. 
			 j-- ; ra[j+1] = ra[j] # above if test duplicates 1st loop of while loop below, so don't need to repeat that check can just adjust j
			 while ( j >left && ra[j-1] > raa )
				{
				 j-- ; ra[j+1] = ra[j] 
				}
			 ra[j] = raa # we know j!=i if we get here due to if statement at start
			}
	  }
   if(L>0) return # insertion sort worked, all done !	 
  } 
 left-- # offset to all array indices
 L=int(n/2)+1;
 ir=n;
 for (;;) 
	{
	 if (L > 1) 
		{
		 rra=ra[--L+left];
		} 
	 else 
		{
		 rra=ra[ir+left];
		 ra[ir+left]=ra[1+left];
		 if (--ir == 1) 
			{
			 ra[1+left]=rra;
			 break;
			}
		}
	 i=L;
	 j=L+L;
	 while (j <= ir) 
		{
		 if (j < ir && ra[j+left] < ra[j+1+left]) j++;
		 if (rra < ra[j+left]) 
			{
			 ra[i+left]=ra[j+left];
			 i=j;
			 j =j+j;
			} 
		 else break;
		}
	 ra[i+left]=rra;
	}
}  
