module Distribution
  module T
    module GSL_
      class << self
        def pdf(x, k)
          GSL::Ran.tdist_pdf(x, k)
        end

        # F cumulative distribution function (cdf).
        #
        # Returns the integral of F-distribution
        # with k1 and k2 degrees of freedom
        # over [0, x].
        #   Distribution::F.cdf(20,3,2)
        #
        def cdf(x, k)
          GSL::Cdf.tdist_P(x.to_f, k)
        end

        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        #
        #   Distribution::F.p_value(0.95,1,2)
        def quantile(pr, k)
          GSL::Cdf.tdist_Pinv(pr, k)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
