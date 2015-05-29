module Distribution
  module ChiSquare
    module GSL_
      class << self
        def rng(_k, _seed = nil)
          nil
        end

        def pdf(x, k)
          GSL::Ran.chisq_pdf(x.to_f, k.to_i)
        end

        # Chi-square cumulative distribution function (cdf).
        #
        # Returns the integral of Chi-squared distribution
        # with k degrees of freedom over [0, x]
        #
        def cdf(x, k)
          GSL::Cdf.chisq_P(x.to_f, k.to_i)
        end

        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        def quantile(pr, k)
          GSL::Cdf.chisq_Pinv(pr.to_f, k.to_i)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
