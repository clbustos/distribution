module Distribution
  module F
    module GSL_
      class << self
        def pdf(x, k1, k2)
          GSL::Ran.fdist_pdf(x.to_f, k1, k2)
        end

        # F cumulative distribution function (cdf).
        #
        # Returns the integral of F-distribution
        # with k1 and k2 degrees of freedom
        # over [0, x].
        #   Distribution::F.cdf(20,3,2)
        #
        def cdf(x, k1, k2)
          GSL::Cdf.fdist_P(x.to_f.to_f, k1, k2)
        end

        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        #
        #   Distribution::F.p_value(0.95,1,2)
        def quantile(pr, k1, k2)
          GSL::Cdf.fdist_Pinv(pr.to_f, k1, k2)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
