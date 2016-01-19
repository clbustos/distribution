module Distribution
  module Uniform
    module GSL_
      class << self
        # Returns a lambda to call for uniformly distributed random numbers
        # returns a double precision float in [0, 1]
        def rng(lower = 0, upper = 1, seed = nil)
          seed = Random.new_seed.modulo 100000007 if seed.nil?
          rng = GSL::Rng.alloc(GSL::Rng::MT19937, seed)
          
          -> { lower + (upper - lower) * rng.uniform }
        end
        
        # :nodoc:
        def pdf(x, lower = 0, upper = 1)
          # rb-gsl/blob/master/ext/gsl_native/randist.c#L1732
          GSL::Ran.flat_pdf(x, lower, upper)
        end
        
        # :nodoc:
        def cdf(x, lower = 0, upper = 1)
          # rb-gsl/blob/master/ext/gsl_native/cdf.c#L644
          GSL::Cdf.flat_P(x, lower, upper)
        end
        
        # :nodoc:
        def quantile(qn, lower, upper)
          # rb-gsl/blob/master/ext/gsl_native/cdf.c#L646
          GSL::Cdf.flat_Pinv(qn, lower, upper)
        end
        
        alias_method :p_value, :quantile
      end
    end
  end
end