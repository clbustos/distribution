module Distribution
  module Binomial
    module GSL_
      class << self
        # Returns a `Proc`object that yields a random integer `k` <= `n`
        # which is binomially distributed with mean np and variance np(1-p)
        # This method only wraps GSL's binomial dist. generator
        #
        # @param n [Fixnum] the total number of trials
        # @param prob [Float] probabilty of success in a single independant trial
        # @param seed [Fixnum, nil] Value to initialize the generator with.
        #   The seed is always taken modulo 100000007. If omitted the value is
        #   remainder of `Random.new_seed` mod 100000007
        #
        # @return [Proc] a proc that generates a binomially distributed integer
        #   `k` <= `n` when called
        def rng(n, prob, seed = nil)
          # Method found at:
          # SciRuby/rb-gsl/ext/gsl_native/randist.c#L1782
          # and
          # SciRuby/rb-gsl/ext/gsl_native/randist.c#L713
          seed = Random.new_seed if seed.nil?
          seed = seed.modulo 100000007
          r = GSL::Rng.alloc(GSL::Rng::MT19937, seed)

          # This is an undocumented function in rb-gsl
          # see gsl_ran_binomial(3) in GSL manual and best guess using
          # http://blackwinter.github.io/rb-gsl/rdoc/rng_rdoc.html
          -> { r.binomial(prob, n) }
        end

        # Returns the probability mass function for a binomial variate
        # having `k` successes out of `n` trials, with each success having
        # probability `prob`.
        #
        # @param k [Fixnum, Bignum] number of successful trials
        # @param n [Fixnum, Bignum] total number of trials
        # @param prob [Float] probabilty of success in a single independant trial
        #
        # @return [Float] the probability mass for Binom(k, n, prob)
        def pdf(k, n, prob)
          GSL::Ran.binomial_pdf(k, prob, n)
        end

        # Returns the cumulative distribution function for a binomial variate
        # having  `k` successes out of `n` trials, with each success having
        # probability `prob`.
        #
        # @param k [Fixnum, Bignum] number of successful trials
        # @param n [Fixnum, Bignum] total number of trials
        # @param prob [Float] probabilty of success in a single independant trial
        #
        # @return [Float] the probability mass for Binom(k, n, prob)
        def cdf(k, n, prob)
          GSL::Cdf.binomial_P(k, prob, n)
        end

        # Returns the inverse-CDF or the quantile given the probability `prob`,
        # the total number of trials `n` and the number of successes `k`
        # Note: This is a custom implementation not derived from GSL.
        #
        #
        # @paran qn [Float] the cumulative function value to be inverted
        # @param n [Fixnum, Bignum] total number of trials
        # @param prob [Float] probabilty of success in a single independant trial
        #
        # @return [Fixnum, Bignum] the integer quantile `k` given cumulative value
        def quantile(qn, n, prob)
          mid = cdf(n * prob, n, prob)
          low, high = 0, n
          
          # @TODO: Ad-hoc, does a binary search, similar to newton raphson
          # still looking for an efficient, scientifically backed method
          while low < high
            mid = cdf((low + high).floor / 2, n, prob)
            lower = cdf(low, n, prob)
            upper = cdf(high, n, prob)
            puts "#{[low, high].inspect}, #{mid}/#{qn}"
            if (qn > lower && qn < upper) && (high - low <= 1)
              # This is the only return since this
              return high
            elsif qn < mid
              high = (low + high) / 2
            elsif
              low = (low + high) / 2
            end
          end
        end
        
        alias_method :p_value, :quantile
      end
    end
  end
end
