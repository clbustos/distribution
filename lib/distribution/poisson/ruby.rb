module Distribution
  module Poisson
    module Ruby_
      class << self
        def pdf(k,l )
          (l**k*Math.exp(-l)).quo(Math.factorial(k))
        end
        def cdf(k,l )
          Math.exp(-l)*(0..k).inject(0) {|ac,i| ac+ (l**i).quo(Math.factorial(i))}
        end
        #def p_value(pr,l )
        #end
      end
    end
  end
end