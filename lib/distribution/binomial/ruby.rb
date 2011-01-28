module Distribution
  module Binomial
    module Ruby_
      class << self
        def pdf(k,n,pr)
          Math.binomial_coefficient(n,k)*(pr**k)*(1-pr)**(n-k)          
        end
        def cdf(k,n,pr)
          #(0..x.floor).inject(0) {|ac,i| ac+pdf(i,n,pr)}
          Math.regularized_beta_function(1-pr,n - k,k+1)
        end
        def p_value(prob,n,pr)
          ac=0
          (0..n).each do |i|
            ac+=pdf(i,n,pr)
            return i if ac>=prob
          end
        end
        
        alias :exact_pdf :pdf 

        
      end
    end
  end
end