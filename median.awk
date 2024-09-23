# In place median of an array
# note array elements must be numbers and array indices must be integers from 1 to n
# median is always assumed to be the int((maxi+1)/2) element of the sorted array (if maxi is odd or even).
# bassed on torben.c downloaded from http://ndevilla.free.fr/median/median/src/torben.c on 25/8/2024 PJM 
# Algorithm by Torben Mogensen, C implementation by N. Devillard.
# C version is in the public domain
# This Awk version by Peter Miller 25-8-2024 is also placed in the public domain
# excutation speed ~ n*log2(n) where n is number of elements in the array
# There are faster algorithms, but they either change the input array or need to take a copy of it.
# see median_test.awk for the corresponding test code
# only tested with wmawk2, but should be portable to other awk interpreters 



function _median(m,from,to   ,n,i, less, greater, equal,min, max, guess, maxltguess, mingtguess) 
   {# m is array,  with integer indices from..to Note the is basically an "internal function", to get the median of the whole array use median()
    n=1+to-from # n is number of elements in array
    min = max = m[from] ;
    for (i=from+1 ; i<=to ; i++) 
		{
         if (m[i]<min) min=m[i];
         if (m[i]>max) max=m[i];
		}
	if(min==max) return min # all values the same
    # now start our search for the median - which must be between min/max. We gradually reduce the range max-min which always brackets the median
    while (1) 
	   {
        guess = (min+max)/2;
        less = 0; greater = 0; equal = 0;
        maxltguess = min ;
        mingtguess = max ;
        for (i=from; i<=to; i++) 
		   {
            if (m[i]<guess) 
			   {
                less++;
                if (m[i]>maxltguess) maxltguess = m[i] ;
               } 
			 else if (m[i]>guess) 
			   {
                greater++;
                if (m[i]<mingtguess) mingtguess = m[i] ;
               } 
			 else equal++;
           }
        if (less <= (n+1)/2 && greater <= (n+1)/2) break ; 
        else if (less>greater) max = maxltguess ;
        else min = mingtguess;
       }
    if (less >= (n+1)/2) return maxltguess;
    else if (less+equal >= (n+1)/2) return guess;
    else return mingtguess;
}

function median(m,n) # this is function most users will want to call
{return _median(m,1,n)
}

