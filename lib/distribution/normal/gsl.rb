module Distribution
  module Normal
    module GSL_
      class << self
        def rng(mean = 0, sigma = 1, seed = nil)
          seed ||= rand(10e8)
          rng = GSL::Rng.alloc(GSL::Rng::MT19937, seed)
          -> { mean + rng.gaussian(sigma) }
        end

        def cdf(x) # :nodoc:
          GSL::Cdf.ugaussian_P(x)
        end

        def pdf(x) # :nodoc:
          GSL::Ran.gaussian_pdf(x)
        end

        def quantile(qn)
          GSL::Cdf.ugaussian_Pinv(qn)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
