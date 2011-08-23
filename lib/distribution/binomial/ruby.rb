module Distribution
  module Binomial
    module Ruby_
      class << self
        def pdf(k,n,pr)
          raise "k>n" if k>n
	  Math.binomial_coefficient(n,k)*(pr**k)*(1-pr)**(n-k)          
        end
        # TODO: Use exact_regularized_beta for 
        # small values and regularized_beta for bigger ones.
        def cdf(k,n,pr)
          #(0..x.floor).inject(0) {|ac,i| ac+pdf(i,n,pr)}
          Math.regularized_beta(1-pr,n - k,k+1)
        end
        def exact_cdf(k,n,pr)
          (0..k).inject(0) {|ac,i| ac+pdf(i,n,pr)}
        end
        def p_value(prob,n,pr)
          ac=0
          (0..n).each do |i|
            ac+=pdf(i,n,pr)
            return i if prob<=ac
          end
        end
        
        alias :exact_pdf :pdf 
      end
    end
  end
end
