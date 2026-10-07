# trig_test.awk
# written by Peter Miller 6/10/2026
# Test code for functions in trig.awk (tan(x), asin(x) and acos(x))
# execute as wmawk2 -f trig.awk -f trig_test.awk
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


BEGIN { # test program
	  CONVFMT="%.10f" # %.14f gives 179 errors , %.13f gives 20 errors
	  PI=3.1415926535897932384626433832795
	  errs=0
	  asin_min=1e300 # min/max values of asin(x) & acos(x)
	  asin_max=-1e300
	  acos_min=1e300
	  acos_max=-1e300
	  atan_min=1e300
	  atan_max=-1e300	  
	  xmin=-1; xmax=1;xinc=1/10000
	  for(x=xmin;x<=xmax;x+=xinc) 
			{if(x+xinc>xmax) x=xmax # ensure we always have exactly xmin, xmax as 2 of the values tested as this gives us the full range for asin(x) and acos(x).
			 x_s=sprintf(CONVFMT,x) # manual says: A numeric expression is converted to string by replacing expr with sprintf(CONVFMT, expr), unless expr can be represented on the host machine as an exact integer then it is converted to sprintf("%d", expr). - unfortunately -1 is therefore an integer
			 s=sin(asin(x))
			 s_s=sprintf(CONVFMT,s)
			 c=cos(acos(x))
			 c_s=sprintf(CONVFMT,c)
			 # check accuracy
			 if(s_s!=x_s)	
				{errs++
				print s_s,x_s
				 printf("At x=%g asin(%g)=%g sin(%g)=%g !=x\n",x,x,asin(x),asin(x),sin(asin(x)))
				}
			 if(c_s!=x_s)	
				{errs++
				 print c_s,x_s
				 printf("At x=%g acos(%g)=%g cos(%g)=%g !=x\n",x,x,acos(x),acos(x),cos(acos(x)))
				}
			# update min/max
			if(asin(x)<asin_min) asin_min=asin(x)
			if(asin(x)>asin_max) asin_max=asin(x)
			if(acos(x)<acos_min) acos_min=acos(x)
			if(acos(x)>acos_max) acos_max=acos(x)		
			# we check tan in an almost identical way, but we need to use atan2(x,1) which gives atan(x/1) = atan(x) 
			# note for atan(x) x is not limited to -1<=x<=1, which means we don't test the full argument range of tan if we just use x
			# so instead we use x/sqrt ((1.0 + x) * (1.0 - x)) which does cover the range -inf to +inf
			xt=x/sqrt ((1.0 + x) * (1.0 - x))
			xt_s=sprintf(CONVFMT,xt)
			t=tan(atan2(xt,1))
			t_s=sprintf(CONVFMT,t)
			# this is more complex as xt can be infinity 
			if(xt_s=="inf" && t<1e16)
				{errs++
				 print t_s,xt_s
				 printf("At x=%g=> xt=%g atan2(%g,1)=%g tan(%g)=%g !=x\n",x,xt,x,atan2(xt,1),atan2(xt,1),tan(atan2(xt,1)))
				}		
			else if(xt_s=="-inf" && t>-1e16)
				{errs++
				 print t_s,xt_s
				 printf("At x=%g=> xt=%g atan2(%g,1)=%g tan(%g)=%g !=x\n",x,xt,x,atan2(xt,1),atan2(xt,1),tan(atan2(xt,1)))
				}	
			 else if(xt_s!="inf"  && xt_s!="-inf" && t_s!=xt_s )	
				{errs++
				 print t_s,xt_s
				 printf("At x=%g=> xt=%g atan2(%g,1)=%g tan(%g)=%g !=x\n",x,xt,x,atan2(xt,1),atan2(xt,1),tan(atan2(xt,1)))
				}		
			if(atan2(xt,1)<atan_min) atan_min=atan2(xt,1)
			if(atan2(xt,1)>atan_max) atan_max=atan2(xt,1)						
		}
     printf("asin returns values from %g (Pi/%g) to %g (Pi/%g) : expect Pi/-2 to +Pi/2\n",asin_min,PI/asin_min,asin_max,PI/asin_max)
	 if(asin_min<-1.58 || asin_min>-1.57) {errs++ ; print "Invalid asin min" } # expect -Pi/2 to Pi/2 
	 if(asin_max<1.57 || asin_max>1.58) {errs++ ; print "Invalid asin max" } 
	 
	 printf("acos returns values from %g (Pi/%g) to %g (Pi/%g) : expect 0 to PI\n",acos_min,PI/acos_min,acos_max,PI/acos_max)
	 if(acos_min<0 || acos_min>1e-6){errs++ ; print "Invalid acos min" }  # expect 0 to Pi
	 if(acos_max<3.14 || acos_max>3.15) {errs++ ; print "Invalid acos max" }  

	 printf("atan2(xt,1) returns values from %g (Pi/%g) to %g (Pi/%g) : expect Pi/-2 to +Pi/2\n",atan_min,PI/atan_min,atan_max,PI/atan_max)
	 if(atan_min<-1.58 || atan_min>-1.57) {errs++ ; print "Invalid atan min" } # expect -Pi/2 to Pi/2 
	 if(atan_max<1.57 || atan_max>1.58) {errs++ ; print "Invalid atan max" } 	 
	 
	 # we don't need to check atan here as that's built into awk and so has already been validated.  tan(x) can give +/- infinity (but here we only check it between +/-1 as that's the range for x and we have already checked that in the main loop above which give -Pi/4 to +Pi/4)
	 
	 if(errs==0) printf("Test finished - no errors \n")
	 else printf("%d errors found in tests\n",errs)
	}