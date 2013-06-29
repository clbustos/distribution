module Distribution
       module Weibull
       	      module Ruby_
	      	     class << self
		     	   def pdf(x, k, lam)
		     	       return 0.0 if x < 0.0
			       return ((k.to_f/lam.to_f)*(x.to_f/lam.to_f)**(k-1.0))*Math.exp(-(x.to_f/lam.to_f)**k)
		     	   end

		     	   #Returns the integral of the Weibull distribution from [-Inf to x]

		     	   def cdf(x, k, lam)
		     	       return 0.0 if x < 0.0
			       return 1.0-Math.exp(-(x.to_f/lam.to_f)**k)
		     	   end

		     	   # Returns the P-value of weibull
		     
			   def p_value(y, k, lam)
		     	       return 1.0 if y > 1.0
			       return 0.0 if y < 0.0
		     	       return -lam*(Math.log(1.0-y))**(1.0/k)
		     	   end
		      end
	      	end
       end
end