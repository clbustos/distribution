module Distribution
  module Normal
    # TODO
    module Java_
      class << self
        #==
        # Generate random variables from the provided distribution
        def rng(mean=0,sigma=1,seed=nil)
          dist = NormalDistributionImpl.new(mean, sigma)
          lambda { dist.sample }
        end
        
        #==
        # Get the inverse cumulative density function (p-value) for qn
        def p_value(qn)
          dist = NormalDistributionImpl.new
          dist.inverseCumulativeProbability(qn)
        end
        
        #==
        # Return the cumulative density function at x
        def cdf(x)
          dist = NormalDistributionImpl.new
          dist.cumulativeProbability(x)
        end
        
        #==
        # Return the probability density function at x
        def pdf(x)
          dist = NormalDistributionImpl.new
          dist.density(x)
        end
      
      end
    end
  end
end