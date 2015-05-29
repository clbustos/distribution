module Distribution
  module Normal
    # TODO
    module Java_
      class << self
        #==
        # Generate random variables from the provided distribution
        def rng(mean = 0, sigma = 1, _seed = nil)
          dist = NormalDistributionImpl.new(mean, sigma)
          -> { dist.sample }
        end

        #==
        # Return the probability density function at x
        def pdf(x)
          dist = NormalDistributionImpl.new
          dist.density(x)
        end

        #==
        # Return the cumulative density function at x
        def cdf(x)
          dist = NormalDistributionImpl.new
          dist.cumulativeProbability(x)
        end

        #==
        # Get the inverse cumulative density function (p-value) for qn
        def quantile(qn)
          dist = NormalDistributionImpl.new
          dist.inverseCumulativeProbability(qn)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
