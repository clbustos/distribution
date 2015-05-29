module Distribution
  module Gamma
    module GSL_
      class << self
        def pdf(x, a, b)
          GSL::Ran.gamma_pdf(x.to_f, a.to_f, b.to_f)
        end

        # Chi-square cumulative distribution function (cdf).
        #
        # Returns the integral of Chi-squared distribution
        # with k degrees of freedom over [0, x]
        #
        def cdf(x, a, b)
          GSL::Cdf.gamma_P(x.to_f, a.to_f, b.to_f)
        end

        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        def quantile(pr, a, b)
          GSL::Cdf.gamma_Pinv(pr.to_f, a.to_f, b.to_f)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
