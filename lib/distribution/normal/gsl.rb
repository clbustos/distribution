module Distribution
  module Normal
    module GSL_
      class <<self
        def cdf(x) # :nodoc:
          GSL::Cdf::ugaussian_P(x)
        end
        def pdf(x) # :nodoc:
          GSL::Ran::gaussian_pdf(x)
        end
        def p_value(qn)
          GSL::Cdf::ugaussian_Pinv(qn)
        end
      end
    end
  end
end
