module Distribution
  module Normal
    module GSL_
      class <<self
        def rng(mean=0,sigma=1,seed=nil)
          seed||=(Time.now.to_f*5).round
          rng=GSL::Rng.alloc(GSL::Rng::MT19937,seed)
          lambda { mean+rng.gaussian(sigma)}
        end
        def cdf(x) # :nodoc:
          GSL::Cdf::ugaussian_P(x)
        end
        def pdf(x) # :nodoc:
          GSL::Ran::gaussian_pdf(x)
        end
        def p_value(qn)
          GSL::Cdf::ugaussian_Pinv(qn)
        end
        def gsl
        end
      end
    end
  end
end
