module Distribution
  module Poisson
    module Ruby_
      class << self

        # Return a Proc object which returns a random number drawn
        # from the poisson distribution with lambda.
        #
        # == Arguments
        #   * +lambda_val+  - mean of the poisson distribution
        #   * +seed+  - seed, an integer value to set the initial state
        #
        # == Algorithm
        #   * Donald Knuth
        #
        def rng(lambda_val = 1, seed = nil)
          seed = Random.new_seed if seed.nil?
          r = Random.new(seed).rand
          x = 0
          l = Math.exp(-lambda_val)
          s = l
          while r > s
            x += 1
            l *= lambda_val / x.to_f
            s += l
          end
          x
        end

        def pdf(k, l)
          (l**k * Math.exp(-l)).quo(Math.factorial(k))
        end

        def cdf(k, l)
          Math.exp(-l) * (0..k).inject(0) { |ac, i| ac + (l**i).quo(Math.factorial(i)) }
        end

        def quantile(prob, l)
          ac = 0
          (0..100).each do |i|
            ac += pdf(i, l)
            return i if prob <= ac
          end
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
