module Distribution
  module F
    module Statistics2_
      class << self
        # F cumulative distribution function (cdf).
        #
        # Returns the integral of F-distribution
        # with k1 and k2 degrees of freedom
        # over [0, x].
        #   Distribution::F.cdf(20,3,2)
        #
        def cdf(x, k1, k2)
          Statistics2.fdist(k1, k2, x)
        end

        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        #
        #   Distribution::F.p_value(0.95,1,2)
        # Statistics2 have some problem with extreme values
        def quantile(pr, k1, k2)
          Statistics2.pfdist(k1, k2, pr)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
