module Distribution
  module Uniform
    module Ruby_
      # Module contain pure ruby implementation of the
      # uniform distribution (rng, pdf, cdf and quantile functions)
      class << self
        # Returns a lambda that emits a uniformly distributed
        # sequence of random numbers between the defined limits
        #
        # == Arguments
        #   * +lower+ - Lower limit of the distribution
        #   * +upper+ - Upper limit of the distribution
        #   * +seed+  - Seed to set the initial state, randomized if ommited
        #
        def rng(lower = 0, upper = 1, seed = nil)
          seed = Random.new_seed if seed.nil?
          prng = Random.new(seed)
          -> { prng.rand * (upper - lower) + lower }
        end

        # Uniform probability density function on [a, b]
        #
        # == Arguments
        # If you are referring the wiki page for this continuous distribution
        # the arguments can be translated as follows
        #   * +x+ - same as continuous random variable
        #   * +lower+ - lower limit or a, must be a real number
        #   * +upper+ - upper limit or b, must be a real number
        #
        # == Reference
        #   * https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)
        #
        # The implementation has been adopted from GSL-1.9 gsl/randist/flat.c
        #
        def pdf(x, lower = 0, upper = 1)
          upper, lower = lower, upper if lower > upper
          return 1 / (upper - lower) if (lower..upper).member? x
          0
        end

        # The uniform cumulative density function (CDF)
        # == Arguments
        # If you are referring the wiki page for this continuous distribution
        # the arguments can be translated as follows
        #   * +x+ - same as continuous random variable
        #   * +lower+ - lower limit or a, must be a real number
        #   * +upper+ - upper limit or b, must be a real number
        #
        # == Reference
        #   * https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)
        #
        # The implementation has been adpoted from GSL-1.9 gsl/cdf/flat.c
        #
        def cdf(x, lower = 0, upper = 1)
          if x < lower
            0
          elsif x > upper
            1
          else
            (x - lower) / (upper - lower)
          end
        end

        # The uniform inverse CDF density function / P-value function
        # == Arguments
        # If you are referring the wiki page for this continuous distribution
        # the arguments can be translated as follows
        #   * +qn+ - same as integral value
        #   * +lower+ - lower limit or a, must be a real number
        #   * +upper+ - upper limit or b, must be a real number
        #
        # == Returns
        #   * nil if the integral value is not in [0, 1]
        #   * inverse cdf otherwise
        # == Reference
        #   * https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)
        #
        # The implementation has been adpoted from GSL-1.9 gsl/cdf/flatinv.c
        #
        def quantile(qn, lower = 0, upper = 1)
          fail RangeError, 'cdf value(qn) must be from [0, 1]. '\
          "Cannot find quantile for qn=#{qn}" if qn > 1 || qn < 0

          qn * upper + (1 - qn) * lower
        end

        alias p_value quantile
      end
    end
  end
end
