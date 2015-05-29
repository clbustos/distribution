module Distribution
  module Poisson
    module Java_
      class << self
        #==
        # Create the PoissonDistributionImpl object for use in calculations
        # with mean of l
        def create_distribution(l)
          PoissonDistributionImpl.new(l)
        end

        #==
        #
        def pdf(k, l)
          dist = create_distribution(l)
          dist.probability(k)
        end

        def cdf(k, l)
          dist = create_distribution(l)
          dist.cumulativeProbability(k)
        end
      end
    end
  end
end
